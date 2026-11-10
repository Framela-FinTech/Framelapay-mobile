# Framela Pay — design-matching handoff

Everything an agent needs to continue matching the app to the Figma boards:
current state, the rules that have been set, and the traps already hit.

Written 2026-11-09, updated 2026-11-10. Branch `dev`.

---

## 1. The design source

Boards are **PNG exports** in `design/`, not a live Figma file. There is no
Figma URL in the repo and the MCP Figma tools have nothing to point at, so
**read the PNGs directly** (crop + sample pixels; see §7).

| Board | Size | State |
|---|---|---|
| `Home Transfer.png` | 22770×12500 | **all four rows done** |
| `History.png` | 9482×6724 | **done** |
| `Beneficiary.png` | 9172×4400 | untouched |
| `Conversion.png` | 6238×3120 | **done** |
| `Edit Profile Picture.png` | 5710×3260 | untouched |
| `Exchange.png` | 8462×5754 | untouched |
| `Help.png` | 10016×7732 | untouched |
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
| 1 | 1209–3842 | Fiat **bank** (22 frames, Home → receipt) | done |
| 2 | 4169–6546 | Wallet / Send Money / Convert Funds, plus Beneficiary and Referral off to the right (13 frames) | done |
| 3 | 6930–8965 | Fiat **card** (9 frames) | done |
| 4 | 9791–11883 | Stablecoin send (19 frames) | done |

**Row 4 draws only the FramelaPay-user path.** There are no frames for the
external-wallet path (`to_external_wallet/`), so those two screens follow the
house conventions rather than a design. Do not go looking for their frames.

### `History.png` row map

| Row | Y range | Frames | State |
|---|---|---|---|
| 1 | 695–3255 | List, the three filter dropdowns, filtered, search, empty state, period picker ×3 | done |
| 2 | 3793–5816 | Receipt in completed / failed / pending, each with the share sheet | done |

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

### Stablecoin (row 4) — DONE

Lives in `transfer/shared/`, `transfer/to_framela_user/` and
`transfer/to_external_wallet/` — there is no `stablecoin/` directory.

`shared/transaction_details_screen.dart` renders through the shared
`ReceiptCard`; the external-wallet screens were brought onto the kit and reuse
`AssetNetworkBar`, the bar the matched sibling screens already carry.

Some stablecoin screens still hand-roll their chrome (inline `AppBar`, raw
`ElevatedButton`, a local `_noticeBanner()` in `shared/review_transfer_screen`).
Those predate the kit; converting them is net-new work, not a restyle.

### Wallet / conversion (row 2) — DONE

`select_wallet_screen` (Send Money), `convert_funds_sheet`,
`choose_wallet_balance_sheet`, `profile/beneficiaries/add_beneficiary_screen`,
`profile/referral/referral_screen`.

**The two boards disagree on how Convert Funds is presented, and both are
implemented.** Home Transfer row 2 draws it as a **bottom sheet** over a
dimmed Send Money, returning with a green banner — that is converting
mid-transfer. Conversion.png draws it as a **full screen** with its own app
bar, preceded by Select From Wallet and followed by completion and a receipt —
that is the standalone journey from the Wallet tab.

The resolution: **split by entry point.** Send Money's convert card opens the
sheet; the Wallet tab's Convert action pushes `convertSelectWallet`. The form
itself lives once, in `convert_funds_form.dart`, and both presentations wrap
it. Change the form, not the wrappers.

`Exchange.png` is still untouched and may re-specify these screens again.

### History — DONE

`features/activity/activity_screen.dart` plus
`profile/statements/receipt_detail_screen.dart`.

The three filter dropdowns **anchor under the chip row**, they are not bottom
sheets — the body is a fixed header plus a `Stack` so the panel has something
to anchor to. The period picker *is* a bottom sheet (it always was); what was
wrong there was its content.

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
- The fiat receipt frame shows "Transaction unsuccessful" on a *completed*
  receipt
- Send Money spells it "the **walet** (currency)"
- The Convert Funds frame reads "£1,000 converted to **$216.50**", which is
  wrong at any real GBP/USD rate — the code computes from the repository rate
- History's category list spells "**Receieved**"
- The History *pending* receipt carries the *failed* receipt's caption
  ("Currency exchange · EUR to NGN") over person-to-person rows, and shows
  €500 in the rows against a €250 headline
- Referral's two frames are identical duplicates

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

- `test/bank_flow_overflow_test.dart` — all bank and card screens, plus the
  Statements receipt in all three states.
- `test/shared_kit_regression_test.dart` — the wallet, stablecoin, History,
  referral, beneficiary and profile screens, the two wallet sheets, and
  interaction checks for the History filter dropdown and period picker.

34 cases in all. Both pump at **360×640** and fail on any `RenderFlex`
overflow.

### THE TEST FONT TRAP — this cost about an hour

`flutter_test`'s default font draws **every glyph as a full em box**, roughly
double real Inter width. Measured: "Saved Beneficiaries" at 17px came out
327.75px against 323px for exactly one em per character.

Without loading the real font, the tests report overflows of 90–220px that
**cannot happen on a device**. Both test files call `_loadInter()` in
`setUpAll`, reading the bundled TTFs from `assets/fonts/`.
**Any new layout test must do the same**, or its numbers are fiction.

Other test notes:

- Prefer fixed `tester.pump(duration)` over `pumpAndSettle` for *screens* —
  `fx_quote`, `card_verification` and the Convert Funds sheet run periodic
  timers that never settle, so `pumpAndSettle` hangs on them.
- **But a fixed pump does not run a bottom sheet's entry animation**, so the
  sheet stays entirely off-screen and any `tap` on it silently misses (a
  `warnIfMissed` warning is the only clue). To *interact* with a sheet, use
  `pumpAndSettle` — safe for the period picker, which has no timer.
- A sheet left off-screen is still laid out, so overflow is caught either way.
  Those are valid layout checks; they are not interaction checks.
- `bank_redirect` auto-advances after 3s and needs a pump past it, or the test
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

`Home Transfer.png`, `History.png` and `Conversion.png` are done. Eleven boards remain.

1. **`KYC.png`, `Settings.png`, `Help.png`** — large surfaces, all still on
   pre-design-pass markers.
2. **`Exchange.png`** — may re-specify the convert screens a third time; worth
   reading before trusting the current split.
3. **`Beneficiary.png`** — the beneficiaries list, details, edit and remove
   screens were out of row 2's scope and are untouched.
4. **Close the asset gaps** — 8 bank logos and the two card marks, once real
   files exist. One line each.
5. **Get eyes on a device.** The largest outstanding risk is that everything is
   layout-verified and fidelity-unverified.

### Behavioural bugs fixed while matching, in case the pattern repeats

Design passes kept turning up real defects. Worth looking for these:

- Convert Funds' amount field had **no `onChanged`**, so the quote never
  recomputed as you typed.
- `MockCurrencyWalletRepository` and `MockFxRepository` carried **different NGN
  rates**, so the convert sheet disagreed with Destination and FX Quote.
- The Wallet tab's Convert action **discarded** the sheet's success message, and
  "Add currency" was wired to an empty callback.
- Referral's "Done" used a bare-name `popUntil` that **empties the navigator**
  when reached from Home.
- History's `_choiceRow` closed itself with `Navigator.pop`, correct for a
  bottom sheet but it would have **popped the History screen** once the panel
  became inline.
- `ConvertQuote` charged a flat fee in the *target* currency and did not deduct
  it; the board says "Fee (included · 1%)" in the source currency.
