alias r := run
alias b := build

default:
    @just --list

# Fetch/update pub dependencies
get:
    flutter pub get

# Run the game in Chrome (debug, hot reload)
run: get
    flutter run -d chrome --web-port=8765

# Run the game as a plain web server (no Chrome auto-launch)
serve: get
    flutter run -d web-server --web-port=8765

# Build an optimized release web bundle into build/web
build: get
    flutter build web --release

# Build and serve the release bundle locally for a final check
build-serve: build
    python3 -m http.server 8766 --directory build/web

# Static analysis
analyze:
    flutter analyze

# Run tests
test:
    flutter test

# Remove build artifacts
clean:
    flutter clean
