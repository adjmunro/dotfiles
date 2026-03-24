# Phone as Mac Microphone

Use a phone as a microphone input source on a Mac.

## iPhone (different Apple ID)

Continuity Camera requires the same Apple ID, so it won't work across accounts.
Use **Camo** or **EpocCam** instead — both work over USB without a matching Apple ID
and install a virtual audio driver so the phone appears as a system input source.

## Android (USB/ADB)

**WO Mic** is the best option:
- Install the WO Mic app on the Android device
- Install the WO Mic driver/client on the Mac
- Connect in USB mode (uses ADB under the hood)
- "WO Mic Device" appears as a system input source

Note: `sndcpy` goes the other direction (Mac audio → Android speaker) — not useful here.
