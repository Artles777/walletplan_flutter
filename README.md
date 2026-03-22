# walletplan

Personal finance accounting app

Repository: `walletplan_flutter`

## Documentation

- [Project docs index](./docs/README.md)
- [Current functionality](./docs/current_functionality.md)

## Current Status

The project already has:
- app shell with `AppBar`, `Drawer`, bottom navigation and central FAB
- nested routing via `beamer`
- transactions tab with local mocked data and composable state
- add income / expense flow via route query parameter `type`
- RU / EN localization via `slang`
- automated tests for current routing, formatting, state and app-level flows

The project still contains placeholders for:
- sign in
- accounts
- plans
- analytics
- income form
- expense form

## Code Generation

For Android Studio / IntelliJ there is a shared run configuration:
- `Codegen Watch`

It runs:
- initial `build_runner build`
- then `build_runner watch`

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
