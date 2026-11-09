# Framela Pay — design-matching handoff

Everything an agent needs to continue matching the app to the Figma boards:
current state, the rules that have been set, and the traps already hit.

Written 2026-11-09. Branch `dev`, HEAD `3d4272c`.

---

## 1. The design source

Boards are **PNG exports** in `design/`, not a live Figma file. There is no
Figma URL in the repo and the MCP Figma tools have nothing to point at, so
**read the PNGs directly** (crop + sample pixels; see §7).

| Board | Size | State |
|---|---|---|
| `Home Transfer.png` | 22770×12500 | rows 1 & 3 done, rows 2 & 4 outstanding |
| `Beneficiary.png` | 9172×4400 | untouched |
| `Conversion.png` | 6238×3120 | untouched |
| `Edit Profile Picture.png` | 5710×3260 | untouched |
| `Exchange.png` | 8462×5754 | untouched |
| `Help.png` | 10016×7732 | untouched |
| `History.png` | 9482×6724 | untouched |
| `KYC.png` | 8964×3596 | untouched |
| `Personal Information Edit.png` | 6268×8626 | untouched |
| `Restriction & Appeal.png` | 19826×8168 | untouched |
| `Settings.png` | 6088×4410 | untouched |
| `Transaction PIN.png` | 16424×10752 | untouched |
| `Transfer Status.png` | 2413×1605 | untouched |
| `Trusted Device.png` | 6924×3806 | untouched |

### `Home Transfer.png` row map

Four rows. Y-ranges are full-resolution pixels.

| Row | Y range | Flow | State |
|---|---|---|---|
| 1 | 1209–3842 | Fiat **bank** (22 frames, Home → receipt) | **done** |
| 2 | ~4169–6546 | Wallet / Send Money / Convert Funds, plus Beneficiary and Referral off to the right | outstanding |
| 3 | 6930–8965 | Fiat **card** (9 frames) | **done** |
| 4 | ~9791–11883 | Stablecoin send | partly done (see §4) |

### THE SCALE RULE

Phone frames are **780px wide = 390 logical pt**, i.e. **@2x**.
**Divide every design pixel measurement by 2** to get Flutter logical units.

---

## 2. Colour rules

### The one-token background decision

The boards disagree with themselves: most of row 1 and row 3's shared screens
use `#FAFBFC`, while Payment Instruction, Review Transfer, Processing,
Completed, Receipt and both card screens use `#F2F4F7`.

**The user decided: one token, `#F2F4F7`.** That is `AppColors.pageGrey`.
Do not reintroduce `#FAFBFC`. Every grey page uses `pageGrey`.

**Exception — genuinely white screens.** `bank_redirect_screen` samples at a
true `#FFFFFF` and stays `AppColors.white`. That is deliberate, not an
oversight. Check the sample before converting a white screen.

### Surface rules

- Page background: `AppColors.pageGrey`
- Cards and form fields: `AppColors.white` plus a **1px `AppColors.divider`
  hairline**; radius 16 for cards, 12 for fields
- `AppColors.inputFill` (`#F5F6FA`) is the **pre-design-pass marker**. On a
  `pageGrey` page it differs by 3 values per channel and the card vanishes.
  Seeing `inputFill` as a card or tile fill means that screen is unmatched.

### Tokens added from sampling (existing values were not changed)

In `lib/core/theme/app_colors.dart`:

| Token | Hex | Used by |
|---|---|---|
| `warningPill` | `#FCEAA1` | FX quote lock pill |
| `warningPanel` | `#FDF3CC` | Payment Instruction notice |
| `infoNotice` | `#E0EDFD` | Review Transfer notice |
| `successNotice` | `#DCF5E7` | Confirm Recipient notice, receipt "Completed" pill |
| `infoHalo` | `#DBEAFE` | FX quote and Card Verification badge haloes |

Already correct and left alone: `success #18794E`, `iconTileSoft #F4F8FD`,
`successSoft #EDFDF5` (halo only), `divider #CBD5E1`, `primaryDark #0B1A33`,
`textGrey #94A3B8`, `primary50 #2B78C4` (link blue), `accentYellow #FFB800`.

### THE TOKEN THRESHOLD RULE

Sampling finds near-duplicates constantly. The rule applied so far:

- **Add a token** when the delta is perceptible. `warningPanel` was added at
  ΔB=23 from `warningSoft`.
- **Reuse** when it is not. The card notice sampled `#FEF8EB` (Δ8 from
  `warningSoft`) and the card badge halo `#DCE7F8` (Δ(1,3,6) from `infoHalo`)
  — both reuse the existing token.

Near-duplicate tokens are how a palette rots. Sample, then judge the delta.

### Type scale (set during the row-1 pass, lives in the shared kit)

| Widget | Size / weight |
|---|---|
| `ScreenHeading` title | 24 / w800 |
| `ScreenHeading` helper | 15 / textGrey |
| `SectionTitle` | 17 / w700 |
| `FieldLabel` | 15 / w600 |
| `SummaryRow` label | 15 / textGrey |
| `SummaryRow` value | 15 / w700 (w800 when `bold`) |
| `AppTextInput` | 16 |
| `whiteAppBar` title | 20 / w700 |
| Buttons | 16 / w600, height 56, radius 14 |

---

## 3. THE SHARED KIT RULE — read before editing

`lib/features/transfer/fiat/widgets/fiat_form_widgets.dart` is imported by
**~57 files** across transfer, profile, KYC, settings, wallet and beneficiaries.

**Every change must be purely additive: new classes, or new OPTIONAL params
whose defaults preserve today's behaviour.**

Never change: `SummaryRow` sizes, `whiteAppBar`, `PrimaryButton`,
`AppTextInput` defaults, or `NoticeBanner`'s existing enum-to-colour mapping.

The kit contains:
`ScreenHeading` (has `center`), `SectionTitle`, `FieldLabel`, `AppTextInput`
(has `prefixIcon`, `onChanged`), `AppDropdownField`, `SummaryRow`,
`NoticeBanner` (has `background`, `iconColor`, `icon`), `TimerPill`,
`PrimaryButton`, `SecondaryButton`, `InfoCard` (has `padding`,
`crossAxisAlignment`), `IconBadge`, `QuoteLockPill`, `SectionHeader`,
`whiteAppBar()`.

Other shared widgets:

- `lib/core/widgets/receipt_card.dart` — `ReceiptCard` + `ReceiptLine`, the
  branded receipt. Parameterized by **primitives**, not by a model, because
  `FiatTransfer` and `TransactionReceipt` do not line up field-for-field.
  Used by both the fiat receipt and the Statements receipt.
- `lib/core/widgets/bank_avatar.dart` — `BankAvatar` plus the `kBankLogos`
  registry, with a glyph fallback.
- `lib/core/widgets/country_dropdown.dart` — `CountryDropdownField`, flags via
  the `country_flags` package.
- `lib/core/widgets/app_icon.dart` — the only place icons are rendered. SVGs
  from `assets/icons/`, Material fallbacks otherwise. **Adding a key is safe;
  changing one is not.**

### Known traps

- **`TimerPill` is used by `convert_funds_sheet.dart`.** Do not restyle it.
  `QuoteLockPill` exists as a separate widget for exactly this reason.
- **`pinput`** is used by `card_verification_screen`, `phone_verification_screen`
  and `verify_email_screen`. Theme it **locally**, never globally.
- **`showShareReceiptSheet`** is shared by four screens. Do not touch.
- **`FiatBeneficiary`** is built `const` in `sampleBeneficiaries` and five
  profile screens. Add **getters**, never required constructor params.

---

## 4. Current state by flow

### Fiat bank (row 1) — DONE

`transfer_details` (Destination) → `select_recipient` → `add_recipient_short`
(Recipient Details) → `add_recipient_full` (Sending Purpose) →
`account_verified` (Confirm Recipient) → `fx_quote` → `bank_redirect` →
`payment_instruction` → `fiat_review_transfer` → `verify_fingerprint` /
`enter_passcode` → `processing_transfer` → `transfer_completed` →
`fiat_transaction_details` (Receipt).

### Fiat card (row 3) — DONE

Identical to bank except `fx_quote` branches on `TransferMethod` to
`pay_with_card` → `card_verification`, then rejoins at `fiat_review_transfer`.
Those two are the only card-specific screens.

### Stablecoin (row 4) — PARTLY DONE

Lives in `transfer/shared/`, `transfer/to_framela_user/` and
`transfer/to_external_wallet/` — there is no `stablecoin/` directory.

Matched earlier: `send_stablecoin_wallet`, `choose_network`,
`send_stablecoin_recipient`, `stablecoin_completed`, `processing_transfer`.

**Not matched** — no Scaffold background, old black 16px app bar:
`to_external_wallet/enter_wallet_address_screen.dart`,
`to_external_wallet/verify_wallet_address_screen.dart`,
`shared/transaction_details_screen.dart`.

Note: **no stablecoin screen imports the shared kit.** They hand-roll app bars,
raw `ElevatedButton`s and a local `_noticeBanner()`. Converting them is net-new
work, not a restyle.

### Wallet / conversion (row 2) — NOT STARTED

`transfer/wallet/convert_funds_sheet.dart`,
`transfer/wallet/select_wallet_screen.dart`, and the `Conversion.png` /
`Exchange.png` boards.

### Shared auth triple

`verify_fingerprint` → `enter_passcode` → `processing_transfer` are shared by
fiat, card and stablecoin, generalised over `TransferAuthFlow`.

---

## 5. Data rules

Business numbers come from **mock repositories**, never hard-coded in widgets
(stated in `fiat_transfer.dart`'s own doc comment).

- `MockCountryRepository` — **246 countries**, generated, each with ISO-2,
  currency code and symbol. `TransferCountry.countryCode` feeds `country_flags`.
- `MockBankRepository` — 25 Nigerian banks.
- `MockCollectionAccountRepository` — FramelaPay's own payin account. Added
  because those values are identical for every transfer and do **not** belong
  on `FiatTransfer`.
- `MockFxRepository` — **NGN rate is 1,567.50**, changed from 1,620.50 to match
  the board. This feeds Destination, FX Quote, Exchange and Conversion.
- `FiatTransfer` defaults are tuned to one coherent scenario matching the board
  and `sampleReceipts[0]`: 500 USD → ₦783,750.00, fee 2.50, reference
  `FRM-20261010-10429`, `10 Oct 2026 · 10:45 AM WAT`.

---

## 6. Assets — the gaps, and why

### Bank logos: 17 of 25 are real

In `assets/icons/banks/`, registered in `kBankLogos`.

**Deliberately missing** (they render the generic glyph): FCMB, Fidelity,
Heritage, Parallex, Polaris, Providus, Titan Trust, Unity.

Why: automated sourcing returns junk. Nine banks returned DuckDuckGo's grey
chevron placeholder, and **Titan Trust returned Union Bank's logo** because
their domain redirects post-acquisition. A wrong mark is worse than none.

**THE RULE: never ship a sourced logo without putting it on a contact sheet and
looking at it.** Byte size alone does not distinguish a real logo from a
placeholder — nine of the junk files were a uniform 1478 bytes.

Access and First Bank are correct but came from 128px favicons, so they are
soft at larger sizes. GTBank is the current GTCO mark, not the older orange one.

### Card brand marks: absent

The Pay With Card header should carry Mastercard and Visa marks. Mastercard
sources correctly; **Visa does not** — the favicon is their abstract blue and
yellow bar device rather than the wordmark, and Wikipedia returns a photo of
their headquarters. Both were omitted rather than ship one correct and one
wrong. There is a comment at the insertion point.

### Country flags: complete, no assets needed

`country_flags: ^3.0.0` is already a dependency and renders by ISO code.

### Trademark note

Bank logos are third-party marks vendored into the repo. Nominative use to
identify a payee is normal for a payments app, but it deserves a licensing
glance before public release.

---

## 7. How to read a board

Three small PIL helpers do the job. They were written in a scratchpad and are
not committed; each is roughly 20 lines.

- **Locate frames in a row** — scan a mid-height line for runs of non-background
  pixels, then report `Counter(img.getdata()).most_common()` per frame. This
  gives both the x-boundaries and the dominant fills.
- **Crop a region** to a readable width for visual inspection.
- **Sample a point** — the dominant colour of a ~24px patch at a full-resolution
  coordinate, for a specific component fill.

`Image.MAX_IMAGE_PIXELS = None` is required — these boards exceed PIL's
decompression-bomb limit.

### Design slips are common — correct them, do not reproduce them

The boards carry copy-paste errors. Found so far:

- Sending Purpose draws the **Relationship field twice**
- Pay With Card carries the Destination screen's heading, a "Select destination
  country" placeholder on Card Number, a second field labelled "Expiry Date"
  where CVV belongs, and picker chevrons on two plain text fields
- Card Verification labels a row **"CArd"**
- The receipt frame shows "Transaction unsuccessful" on a *completed* receipt

**The user's standing decision: implement the sensible version and leave a
one-line code comment noting the board's version.**

---

## 8. Verification — read this, it has cost real time

### DO NOT RUN `flutter analyze` CASUALLY

On this machine the first run of a session takes **~15 minutes**. The user has
a standing instruction against it (the `avoid-flutter-analyze-cli` memory).
Prefer `mcp__ide__getDiagnostics` when the IDE MCP server is connected. When it
is not, **use `flutter test`** — it compiles everything it touches and surfaces
real errors in under a minute. Run `flutter analyze` at most once as a final
gate; subsequent runs in the same session are ~10s warm.

### The layout tests

- `test/bank_flow_overflow_test.dart` — 16 cases: all bank and card screens,
  plus the Statements receipt in all three states.
- `test/shared_kit_regression_test.dart` — 9 cases: the non-transfer screens
  exposed to the shared kit and the FX rate change.

Both pump at **360×640** and fail on any `RenderFlex` overflow.

### THE TEST FONT TRAP — this cost about an hour

`flutter_test`'s default font draws **every glyph as a full em box**, roughly
double real Inter width. Measured: "Saved Beneficiaries" at 17px came out
327.75px against 323px for exactly one em per character.

Without loading the real font, the tests report overflows of 90–220px that
**cannot happen on a device**. Both test files call `_loadInter()` in
`setUpAll`, reading the bundled TTFs from `assets/fonts/`.
**Any new layout test must do the same**, or its numbers are fiction.

Other test notes: use fixed `tester.pump(duration)`, never `pumpAndSettle` —
`fx_quote` and `card_verification` run periodic timers that never settle.
`bank_redirect` auto-advances after 3s and needs a pump past it, or the test
fails on a pending timer.

### What is NOT verified

There is **no emulator on this machine** (Windows desktop and Edge only), and a
`flutter run -d web-server` attempt was killed at its time limit. Nothing has
been confirmed **visually on a device**. The layout tests prove there is no
overflow; they prove nothing about fidelity to the board.

---

## 9. Conventions

- **Commits**: one line, `Update: <what>`. No body, **no attribution footer**,
  no `Co-Authored-By`. This overrides the harness default.
- **Branch**: `dev`. Do not open a pull request unless asked.
- Comment density matches the surrounding code — explain *why*, especially
  where a design slip was corrected or a trap avoided.
- `Navigator.popUntil` with a bare name predicate **empties the navigator** if
  that route is absent. Always `(r) => r.settings.name == X || r.isFirst`.

---

## 10. Suggested next steps

1. **Row 2** — wallet / Send Money / Convert Funds, plus `Conversion.png` and
   `Exchange.png`. `convert_funds_sheet` has never been matched.
2. **Stablecoin leftovers** — the three screens in §4 with no background and
   the old app bar.
3. **The other 13 boards** — KYC, Settings, History and Help are probably the
   highest value.
4. **Close the asset gaps** — 8 bank logos and the two card marks, once real
   files exist. One line each.
5. **Get eyes on a device.** The largest outstanding risk is that everything is
   layout-verified and fidelity-unverified.
