# Apple Watch Mac Auth (Cross-Apple-ID)

**Goal:** Use Apple Watch to auto-unlock Touch ID prompts on a work Mac (different Apple ID from Watch), via BLE proximity — no third-party dependencies.

## Motivation

- macOS Auto Unlock requires same Apple ID on both Mac and Watch — doesn't work with personal Watch + work Mac
- Want: proximity-based lock/unlock + auto-approve Touch ID prompts (sudo, 1Password, etc.)
- BLE is Apple-ID-independent, so it's the right transport layer

## Architecture

### 1. watchOS App (BLE Peripheral)
- Advertises a BLE service when Watch is worn and unlocked
- Challenge-response for security (prevent any Watch from unlocking)
- Background BLE advertising is limited on watchOS — needs a complication or always-on workaround

### 2. macOS Daemon (BLE Central)
- Scans for Watch's BLE service, monitors RSSI for proximity
- Triggers `pmset` / `loginwindow` lock on departure
- Signals "in range" for unlock flows

### 3. Authentication Hook (the hard part)

| Goal | Mechanism | Difficulty |
|------|-----------|------------|
| Lock screen on departure | `pmset` / `loginwindow` | Easy |
| Unlock login screen | PAM module | Hard |
| sudo prompts | PAM module (replace `pam_tid.so`) | Hard |
| Touch ID app prompts (1Password, etc.) | PAM or `LocalAuthentication` hook | Very Hard |

## Key Challenges

- **PAM modules** require SIP partial disable or system path install — annoying on managed Macs
- **Auto-approving Touch ID popups** — no public API for externally approving `LAContext` evaluations; Apple actively resists this
- **Work Mac MDM** may block BLE entitlements, daemon installs, or PAM modifications
- **watchOS background limits** — Watch app needs to stay alive; requires complication or always-on workaround

## Realistic Scope for a Weekend

- **Proximity lock** (lock when Watch leaves range): genuinely weekend-project territory
- **Auto-approve Touch ID prompts**: research-project territory — custom PAM module checking BLE state; won't intercept app-level `LAContext` without deeper hooks Apple blocks on managed hardware

## Prior Art / Related Projects

- Near Lock (paid app, similar concept)
- Search GitHub: `apple watch mac lock proximity`
- macOS built-in Auto Unlock (same Apple ID only)
- `pam_tid.so` — built-in PAM module for Touch ID, can be added to `/etc/pam.d/sudo`

## Starting Points

1. CoreBluetooth on macOS (central) + WatchConnectivity or CoreBluetooth on watchOS (peripheral)
2. `pmset displaysleepnow` or `open -a ScreenSaverEngine` for lock trigger
3. Research PAM module writing on macOS for the auth side
4. Check work Mac MDM restrictions before investing in PAM approach
