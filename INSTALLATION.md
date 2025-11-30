# Installation Instructions

## Prerequisites

Before running this project, make sure you have the following installed:

- Ruby 3.2.1
- Rails 8.1.1
- SQLite3
- Bundler

## Installation Steps

### 1. Clone the Repository
```bash
git clone https://github.com/truongle7793/url-shortener-app.git
cd url-shortener-app
```

### 2. Install Dependencies
```bash
bundle install
```

### 3. Setup Database
```bash
rails db:create
rails db:migrate
```

### 4. Start the Server
```bash
rails s
```

The API will be available at `http://127.0.0.1:3000/` or `http://localhost:3000`
with the 2 endpoints `/encode` and `/decode`

## Testing the API
 You can use the command below or use Postman.
### Encode a URL
```bash
curl -X POST http://localhost:3000/encode \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```

**Response:**
```json
{
  "original_url": "https://example.com",
  "code": "abc123",
  "short_url": "http://localhost:3000/abc123"
}
```

### Decode a Short Code
```bash
curl -X POST http://localhost:3000/decode \
  -H "Content-Type: application/json" \
  -d '{"code": "abc123"}'
```

**Response:**
```json
{
  "code": "abc123",
  "original_url": "https://example.com"
}
```

## Running Tests
```bash
# Run all tests
bundle exec rspec

# Run with documentation format
bundle exec rspec --format documentation
```
