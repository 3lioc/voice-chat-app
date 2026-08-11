# RIVO
Real-time voice community app.

## Current foundation
- Flutter Android app
- Working navigation and interactive UI
- Room screen with 10 seats
- Microphone state control
- Local chat composer
- Settings screen

## Production integrations still required
- Supabase URL + anon key
- Database schema + RLS
- Auth
- Agora App ID + secure token server
- Push notifications
- Google Play Billing for virtual goods
- Moderation/admin backend


## Build status
The Android manifest uses Flutter Android embedding v2. The app also supports demo/local mode when Supabase credentials are not configured; real accounts, rooms, chat, and voice require the production backend credentials and Agora configuration.
