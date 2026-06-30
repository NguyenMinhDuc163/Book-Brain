# SPEC Backend: Guest/Public API Contract for Book Brain App Store Review

## 1. Context

The Flutter app has implemented guest mode to comply with Apple App Store Guideline 5.1.1(v).

Apple rejected the app because users were required to register/login before browsing and reading books.

Frontend behavior after update:

* A clean install opens `MainApp/Home` directly; Login is not shown first.
* If `authToken` is missing, Flutter persists `isGuest=true` before opening Home.
* Guest users can browse/search/read books.
* Guest users will not call account-based APIs.
* Guest users will not send `userId`.
* The current Flutter networking layer normally sends `Authorization: Bearer `
  for a guest because the Dio header is initialized globally.
* Login remains available from the Home avatar, Settings, and restricted-action dialogs.

This backend SPEC defines the API behavior required to match the Flutter guest mode.

## 2. Goal

Allow unauthenticated users to access non-account-based content APIs.

Guest users must be able to call public content APIs without login:

```text id="29gaf2"
GET /books
GET /books/trending
GET /books/search
GET /detailBook
GET /books/chapters
GET /books_reviews
GET /reviews/stats
GET /rankings/authors
GET /rankings/books
```

Private/account APIs must remain protected:

```text id="k8jj83"
favorites
subscriptions
notifications
reading history
book notes
review write/delete
profile update
change password
delete account
personalized recommendations by userId
```

## 3. Non-goals

Do not make all APIs public.

Do not allow guest users to write user data.

Do not support guest notes/history sync in this task.

Do not change Flutter response model shape unless necessary.

Do not require Flutter to send fake `userId`.

Do not default `userId` to `1`.

Do not default missing `bookId` to `1`.

Do not create a new auth system.

## 4. Shared FE/BE contract

## 4.1 Auth states

Backend must support two request states.

### Logged-in user

Request has valid JWT:

```text id="ecioxg"
Authorization: Bearer <valid_token>
```

Backend should set:

```text id="wr71z5"
req.user = decoded user
```

### Guest user

Request has no valid user token.

Possible guest request formats from Flutter:

```text id="6gdwgd"
No Authorization header
```

or current Flutter behavior may send:

```text id="4wfyaf"
Authorization: Bearer
```

or:

```text id="ljs2u4"
Authorization: Bearer 
```

or:

```text id="2jziyv"
Authorization: Bearer null
```

or:

```text id="bukog5"
Authorization: Bearer undefined
```

For public GET routes, all of the above should be treated as guest, not as a hard auth failure.

## 4.2 Public routes must use optional auth

Public routes must use optional auth behavior:

```text id="i9s0fu"
If token is missing/empty/null/undefined -> req.user = null -> continue.
If token is valid -> req.user = decoded user -> continue.
If token is invalid/expired/malformed -> req.user = null -> continue for public GET routes.
```

Important:

* Do not return 401 on public GET routes because token is absent or invalid.
* Invalid token on public route should degrade to guest.
* Strict auth remains required on private routes.

## 4.3 Private routes must use strict auth

Private routes must use strict auth behavior:

```text id="k5g8q8"
If token is missing/empty/null/undefined -> 401.
If token is invalid/expired/malformed -> 401.
If token is valid -> continue.
```

## 5. Middleware requirements

## 5.1 Add optionalAuth middleware

Implement or update middleware:

```js id="ui16ft"
function optionalAuth(req, res, next) {
  const raw = req.headers.authorization || "";
  const token = extractBearerToken(raw);

  if (!token) {
    req.user = null;
    return next();
  }

  try {
    req.user = verifyJwt(token);
  } catch (e) {
    req.user = null;
  }

  return next();
}
```

Token extraction must treat these as no token:

```text id="vzflqy"
""
"Bearer"
"Bearer "
"Bearer null"
"Bearer undefined"
"null"
"undefined"
```

Example helper:

```js id="qbs8hm"
function extractBearerToken(authorizationHeader) {
  if (!authorizationHeader) return null;

  const value = authorizationHeader.trim();

  if (!value) return null;

  const lower = value.toLowerCase();

  if (lower === "bearer") return null;
  if (lower === "null") return null;
  if (lower === "undefined") return null;

  if (!lower.startsWith("bearer ")) {
    return null;
  }

  const token = value.slice(7).trim();

  if (!token) return null;
  if (token.toLowerCase() === "null") return null;
  if (token.toLowerCase() === "undefined") return null;

  return token;
}
```

## 5.2 Keep requireAuth middleware for private APIs

Existing auth middleware can remain for private APIs.

Expected behavior:

```js id="3xcmds"
function requireAuth(req, res, next) {
  const token = extractBearerToken(req.headers.authorization || "");

  if (!token) {
    return res.status(401).json({
      code: 401,
      message: "Unauthorized"
    });
  }

  try {
    req.user = verifyJwt(token);
    return next();
  } catch (e) {
    return res.status(401).json({
      code: 401,
      message: "Unauthorized"
    });
  }
}
```

## 6. Public API routing

Use `optionalAuth` for these routes.

```text id="xpikml"
GET /books
GET /books/trending
GET /books/search
GET /detailBook
GET /books/chapters
GET /books_reviews
GET /reviews/stats
GET /rankings/authors
GET /rankings/books
```

These are public because they are content browsing/reading/review-view/ranking APIs.

## 7. Private API routing

Use `requireAuth` for these routes.

```text id="m1z2da"
POST /auth/update
POST /auth/change_password
POST /auth/delete

GET /favorites
POST /favorites

GET /subscriptions
POST /subscriptions

GET /notifications
POST /notifications

GET /reading_history
POST /reading_history

GET /book_notes
POST /book_notes
POST /book_notes/delete

POST /reviews
POST /reviews/delete

GET /recommendations
POST /rankings/update
```

Notes:

* `GET /recommendations` remains private if it requires `user_id`.
* `POST /reviews` remains private because writing a review is account-based.
* `GET /books_reviews` is public because viewing reviews is non-account-based.
* `GET /reviews/stats` is public because viewing aggregate stats is non-account-based.

## 8. API contract details

## 8.1 `GET /books`

Access:

```text id="i6wnk5"
Guest: allowed
Logged-in: allowed
```

Required query params:

```text id="wzn6vh"
None
```

Behavior:

* Return book list.
* Do not require token.
* Do not require userId.
* Do not return user-private data.

Response shape:

Keep current response shape expected by Flutter.

## 8.2 `GET /books/trending`

Access:

```text id="j7ii82"
Guest: allowed
Logged-in: allowed
```

Required query params:

```text id="gvu8gk"
limit
```

Validation:

* If `limit` missing, use safe default such as `10`, or return 400 if current API already requires it.
* Prefer safe default to reduce Flutter regression.

Behavior:

* Return trending books.
* Do not require token.
* Do not require userId.

## 8.3 `GET /books/search`

Access:

```text id="u2kv4d"
Guest: allowed
Logged-in: allowed
```

Required query params:

```text id="s5xseg"
keyword
limit
```

Validation:

* If `keyword` missing or empty, return empty list with 200, or return 400 if current client handles it.
* Prefer 200 with empty list for app stability.
* If `limit` missing, use default `10`.

Behavior:

* Return matching books.
* Do not require token.
* Do not require userId.

## 8.4 `GET /detailBook`

Access:

```text id="z7zj0x"
Guest: allowed
Logged-in: allowed
```

Required query params:

```text id="rjheiw"
id
chapter
```

Meaning:

```text id="phajln"
id = bookId
chapter = chapter number or chapter id, according to current backend behavior
```

Validation:

* If `id` missing -> 400.
* If `chapter` missing -> 400 or default to first chapter only if this is existing behavior and Flutter depends on it.
* Do not default missing `id` to `1`.
* If book does not exist -> return 404 or current standard empty response.
* Do not return 401 for guest.

User-specific fields:

The exact Flutter wire keys are:

```json id="hkxxj1"
{
  "is_favorited": true,
  "is_subscribed": true
}
```

then for guest return:

```json id="dcnv3i"
{
  "is_favorited": false,
  "is_subscribed": false
}
```

If logged-in and token valid, compute actual values for that user.

Important:

* Book content/chapter content must be returned to guest.
* Guest should be able to read the book.
* Do not require `userId`.

## 8.5 `GET /books/chapters`

Access:

```text id="q7jz1z"
Guest: allowed
Logged-in: allowed
```

Required query params:

```text id="3do8ps"
bookId
```

Validation:

* If `bookId` missing -> 400.
* If book does not exist -> empty list or 404 based on existing convention.
* Do not return 401 for guest.

Behavior:

* Return chapter list for a book.
* Do not require userId.

## 8.6 `GET /books_reviews`

Access:

```text id="zya6i0"
Guest: allowed
Logged-in: allowed
```

Required query params:

```text id="qjxz7c"
book_id
page
limit
```

Validation:

* If `book_id` missing -> 400.
* If `page` missing -> default `1`.
* If `limit` missing -> default `10`.

Behavior:

* Return public reviews for a book.
* Do not require token.
* Do not require userId.
* Do not expose private user fields beyond display info already used by app.

## 8.7 `GET /reviews/stats`

Access:

```text id="sp0t0x"
Guest: allowed
Logged-in: allowed
```

Required query params:

```text id="27dtsq"
bookId
```

Validation:

* If `bookId` missing -> 400.
* If no reviews -> return zero stats instead of 500.

Behavior:

* Return aggregate review statistics.
* Do not require token.
* Do not require userId.
* A successful response must contain exactly one stats object (either `data:
  {...}` or `data: [{...}]`). Do not return `data: []` for a valid book with no
  reviews because the current Flutter service reads `data[0]`.
* For no reviews, return the zero-valued object documented in section 18.4.

## 8.8 `GET /rankings/authors`

Access:

```text id="i5ob48"
Guest: allowed
Logged-in: allowed
```

Required query params:

```text id="ewb1w7"
limit
```

Validation:

* If `limit` missing -> default `5` or `10`.

Behavior:

* Return author rankings.
* Do not require token.
* Do not require userId.

## 8.9 `GET /rankings/books`

Access:

```text id="7yo5j9"
Guest: allowed
Logged-in: allowed
```

Required query params:

```text id="0iq75n"
limit
```

Validation:

* If `limit` missing -> default `5` or `10`.

Behavior:

* Return book rankings.
* Do not require token.
* Do not require userId.

## 9. Private API contract details

## 9.1 Favorites

Routes:

```text id="ejeobu"
GET /favorites
POST /favorites
```

Access:

```text id="79265g"
Guest: 401
Logged-in: allowed
```

Behavior:

* Use authenticated user from token.
* Do not accept `userId` from client for authorization.
* `POST /favorites` can receive `bookId` and `action`.
* If guest tries this, return 401.

Expected Flutter behavior:

* Flutter guest should not call this.
* If accidentally called, backend returns 401.

## 9.2 Subscriptions / following

Routes:

```text id="ktq6aw"
GET /subscriptions
POST /subscriptions
```

Access:

```text id="8njxlb"
Guest: 401
Logged-in: allowed
```

Behavior:

* Use authenticated user from token.
* `POST /subscriptions` receives `bookId` and `action`.
* If guest, return 401.

## 9.3 Notifications

Routes:

```text id="lxj48k"
GET /notifications
POST /notifications
```

Access:

```text id="h49pzg"
Guest: 401
Logged-in: allowed
```

Behavior:

* Notifications are account-based.
* Use authenticated user from token.

## 9.4 Reading history

Routes:

```text id="fmab66"
GET /reading_history
POST /reading_history
```

Access:

```text id="ivnibk"
Guest: 401
Logged-in: allowed
```

Behavior:

* Reading history is user-specific.
* Use authenticated user from token.
* `POST` may receive `bookId`, `currentChapterId`, `readingStatus`, `completionRate`, `notes`.

## 9.5 Book notes

Routes:

```text id="xbefg3"
GET /book_notes
POST /book_notes
POST /book_notes/delete
```

Access:

```text id="fthdfd"
Guest: 401
Logged-in: allowed
```

Behavior:

* Notes are user-specific.
* Use authenticated user from token.
* `GET` can receive `bookId`, `chapterId`.
* Do not return another user's notes.

## 9.6 Review write/delete

Routes:

```text id="qzfwov"
POST /reviews
POST /reviews/delete
```

Access:

```text id="hh2alo"
Guest: 401
Logged-in: allowed
```

Behavior:

* Viewing reviews is public.
* Writing/deleting reviews requires logged-in account.
* Use authenticated user from token.
* Do not accept client-supplied `userId`.

## 9.7 Profile/account

Routes:

```text id="2jm7ba"
POST /auth/update
POST /auth/change_password
POST /auth/delete
```

Access:

```text id="pg94yu"
Guest: 401
Logged-in: allowed
```

Behavior:

* Use authenticated user from token.

## 9.8 Recommendations

Current route:

```text id="98ujm3"
GET /recommendations?user_id=&limit=
```

For this release:

```text id="3kidpu"
Guest: 401 or not used
Logged-in: allowed
```

Important:

* Flutter guest will not call this route.
* Do not require backend guest recommendation support.
* Do not default missing `user_id` to 1.
* If `user_id` missing and route remains private, return 400 or 401 based on auth convention.
* Prefer deriving userId from token instead of trusting query `user_id` in a future improvement.

## 10. Response format consistency

Do not change the response envelope expected by Flutter.

If current response format is:

```json id="xvuc71"
{
  "code": 200,
  "message": "...",
  "data": []
}
```

keep it.

For validation errors:

```json id="7wmzvq"
{
  "code": 400,
  "message": "Missing required parameter: bookId",
  "data": []
}
```

For unauthorized private APIs:

```json id="203f9x"
{
  "code": 401,
  "message": "Unauthorized",
  "data": []
}
```

Avoid returning raw server errors.

Avoid returning HTML error pages.

Avoid changing `data` type if Flutter expects a list.

For current Flutter compatibility, successful `GET /detailBook` and
`GET /reviews/stats` responses must contain one non-empty object. `BaseResponse`
can parse either an object or a one-item list, but the feature services then
read the first parsed item.

## 11. ID handling rules

## 11.1 Content IDs

These can be used by guest:

```text id="kbbf0o"
bookId
chapterId/chapter
book_id
reviewId only for private delete action
```

Public APIs may require content IDs.

Examples:

```text id="gh6w5r"
GET /detailBook?id=12&chapter=1
GET /books/chapters?bookId=12
GET /books_reviews?book_id=12&page=1&limit=10
GET /reviews/stats?bookId=12
```

Guest can provide these because they come from public book lists.

## 11.2 User IDs

Guest never has userId.

Rules:

```text id="i0jud3"
Do not require userId on public content APIs.
Do not ask Flutter guest to send userId.
Do not default userId to 1.
Do not trust client userId for private ownership.
Prefer token-derived user id for private APIs.
```

## 11.3 Missing IDs

If required content ID is missing:

```text id="j5shq4"
Return 400, not 401.
Do not default to ID 1.
Do not crash.
Do not return unrelated data.
```

Example:

```json id="77auci"
{
  "code": 400,
  "message": "Missing required parameter: id",
  "data": []
}
```

## 12. Security requirements

* Public APIs must be read-only.
* Public APIs must not expose private user data.
* Guest must not be able to write favorites/subscriptions/history/notes/reviews.
* Private APIs must use strict auth.
* Do not authorize based on client-sent `userId`.
* For private data, always scope by authenticated token user.
* Optional auth on public routes must never throw unhandled exceptions.
* Empty Bearer token must not crash auth middleware.
* Invalid token on public routes should not block reading/browsing.

## 13. Logging requirements

Log auth problems safely.

For public routes:

```text id="3bbat1"
Invalid/missing token -> treat as guest.
Do not log full JWT.
Do not log passwords.
```

For private routes:

```text id="qpd0wz"
Invalid/missing token -> return 401.
Do not log full JWT.
```

## 14. Testing requirements

## 14.1 Public API tests without Authorization header

These must return success:

```text id="29lerm"
GET /books
GET /books/trending?limit=10
GET /books/search?keyword=a&limit=10
GET /detailBook?id=1&chapter=1
GET /books/chapters?bookId=1
GET /books_reviews?book_id=1&page=1&limit=10
GET /reviews/stats?bookId=1
GET /rankings/authors?limit=5
GET /rankings/books?limit=5
```

Expected:

```text id="u787ad"
200 or current success code
No 401
No 500
Response shape unchanged
```

## 14.2 Public API tests with empty Authorization header

These must also not return 401:

```bash id="ps305e"
curl -H "Authorization: Bearer " "/books"
curl -H "Authorization: Bearer null" "/books"
curl -H "Authorization: Bearer undefined" "/books"
curl -H "Authorization: Bearer " "/detailBook?id=1&chapter=1"
```

Expected:

```text id="dncx54"
Treat as guest
Return content if params are valid
No 401
No 500
```

## 14.3 Public API tests with invalid Authorization header

```bash id="dcvabv"
curl -H "Authorization: Bearer invalid-token" "/books"
curl -H "Authorization: Bearer invalid-token" "/detailBook?id=1&chapter=1"
```

Expected:

```text id="qjwlz1"
Treat as guest
No 401
No 500
```

## 14.4 Missing content ID tests

```text id="bda2s3"
GET /detailBook
GET /books/chapters
GET /books_reviews
GET /reviews/stats
```

Expected:

```text id="7e7vcc"
400
No 401
No 500
Clear message
```

## 14.5 Private API tests without token

These must return 401:

```text id="wpu5gj"
GET /favorites
POST /favorites
GET /subscriptions
POST /subscriptions
GET /notifications
GET /reading_history
POST /reading_history
GET /book_notes
POST /book_notes
POST /reviews
POST /reviews/delete
POST /auth/update
POST /auth/change_password
POST /auth/delete
GET /recommendations?user_id=1&limit=10
```

Expected:

```text id="yexc4i"
401 Unauthorized
No private data returned
```

## 14.6 Private API tests with valid token

Existing logged-in behavior must continue working.

Test:

```text id="d8v343"
favorite add/remove
subscription add/remove
notifications list/mark/delete
reading history get/update
notes get/save/delete
review create/delete
profile update
change password
delete account
recommendations
```

Expected:

```text id="5w4x97"
Same as before
No regression
```

## 15. Rollout plan

Implement in this order:

```text id="2f7fkz"
1. Add robust token extraction helper.
2. Add optionalAuth middleware.
3. Apply optionalAuth only to public GET routes.
4. Confirm private routes still use requireAuth.
5. Adjust public detail/review/ranking controllers to handle req.user = null.
6. Ensure guest response sets `is_favorited`/`is_subscribed` false.
7. Add validation for required content IDs.
8. Run public API tests.
9. Run private API tests.
10. Coordinate with Flutter build using guest mode.
```

## 16. Coordination with Flutter SPEC

The Flutter app currently does the following:

```text id="xa3gyd"
- Allow users to enter MainApp as guest.
- Not call /notifications for guest.
- Not call /recommendations for guest.
- Not call /favorites for guest.
- Not call /subscriptions for guest.
- Not call /reading_history for guest.
- Not call /book_notes for guest.
- Not call POST /reviews for guest.
- Still call /books, /books/trending, /books/search, /detailBook, /books/chapters, /books_reviews, /reviews/stats, /rankings/* as guest.
```

Backend must therefore:

```text id="e2pt14"
- Allow public content GET APIs without auth.
- Keep private user APIs protected.
- Treat empty Authorization as guest for public APIs.
- Never require userId for public content APIs.
```

## 17. Definition of done

Backend is done when:

```text id="64el3m"
[ ] Public content APIs work without token.
[ ] Public content APIs work with empty Bearer token.
[ ] Public content APIs work with invalid Bearer token by treating as guest.
[ ] Private APIs still return 401 without token.
[ ] Public APIs do not require userId.
[ ] Public APIs requiring bookId/chapterId return 400 when missing.
[ ] detailBook returns readable content to guest.
[ ] detailBook returns `is_favorited=false` and `is_subscribed=false` for guest.
[ ] Existing logged-in behavior still works.
[ ] Response shape remains compatible with Flutter.
```

## 18. Exact Flutter wire contract (implementation handoff)

This section was verified against the current Flutter `ApiServices`, request
models, and response models. When this section conflicts with a generic example
above, follow this section for the current release.

## 18.1 Base URL and route names

Flutter sends the following relative paths without a leading slash:

```text
auth/login
auth/register
books
books/trending
recommendations
books/search
detailBook
books/chapters
reviews
reviews/delete
books_reviews
reviews/stats
favorites
subscriptions
notifications
reading_history
rankings/update
rankings/authors
rankings/books
auth/change_password
auth/update
auth/delete
book_notes
book_notes/delete
```

The backend router may mount these paths under a shared prefix, but the deployed
base URL and route mounting must preserve the final URLs expected by Flutter.
Treat route spelling and casing as significant, especially `detailBook`.

## 18.2 Exact public query parameters

```text
GET books
  no query

GET books/trending
  limit: integer

GET books/search
  keyword: string
  limit: integer

GET detailBook
  id: integer book id
  chapter: integer chapter order/id according to existing behavior

GET books/chapters
  bookId: integer

GET books_reviews
  book_id: integer
  page: integer
  limit: integer

GET reviews/stats
  bookId: integer

GET rankings/authors
  limit: integer

GET rankings/books
  limit: integer
```

Do not silently rename snake_case parameters to camelCase or the reverse. The
mixed naming above is the current production client contract.

## 18.3 Exact private request payloads

Flutter currently sends:

```json
POST /favorites
{ "book_id": 12, "action": "add" }

POST /favorites
{ "book_id": 12, "action": "remove" }

POST /subscriptions
{
  "book_id": 12,
  "action": "subscribe",
  "notification_method": null
}

POST /subscriptions
{
  "book_id": 12,
  "action": "unsubscribe",
  "notification_method": null
}

POST /notifications
{ "action": "mark_read", "notification_id": 25 }

POST /notifications
{ "action": "delete", "notification_id": 25 }

POST /notifications
{ "action": "mark_all_read" }

POST /notifications
{ "action": "delete_all" }

POST /reading_history
{
  "book_id": 12,
  "reading_status": "reading",
  "completion_rate": 4.5,
  "notes": "",
  "current_chapter_id": 3
}

POST /book_notes
{
  "bookId": 12,
  "chapterId": 3,
  "selectedText": "...",
  "noteContent": "...",
  "startPosition": 10,
  "endPosition": 20
}

POST /book_notes/delete
{ "noteId": 99 }

POST /reviews
{ "book_id": 12, "rating": 5, "comment": "..." }

POST /reviews/delete
{ "review_id": 77 }

POST /auth/update
{
  "id": 7,
  "email": "reader@example.com",
  "phone_number": "0987654321",
  "click_send_name": null,
  "click_send_key": null,
  "username": "reader"
}

POST /auth/change_password
{ "id": 7, "oldPassword": "...", "newPassword": "..." }

POST /auth/delete
{}
```

For every private route, ownership comes from the verified JWT. Client fields
such as `id` may be accepted for backward compatibility but must not be used as
the authorization identity. Prefer ignoring them or verifying that they equal
`req.user.id`.

### Current `active_only` compatibility issue

The intended request is:

```text
GET /subscriptions?page=1&limit=10&active_only=true
```

The current Flutter implementation accidentally sends the numeric `limit`
value as `active_only` (for example `active_only=10`). Until the mobile bug is
fixed and deployed, backend parsing should accept:

```text
true, "true", 1, or any positive integer -> true
false, "false", 0 -> false
```

Do not fail the current app with a strict boolean-only validator for this query
parameter. Track removal of numeric compatibility as a later cleanup.

## 18.4 Response value types required by Dart models

Do not change numeric-looking strings to JSON numbers without coordinating a
Flutter model migration. Several current Dart fields are declared as `String?`
and will throw a runtime type error if the backend starts returning integers or
doubles.

Keep these values as JSON strings:

```text
Book/search/trending:
  rating

Review stats:
  total_reviews
  average_rating
  five_star
  four_star
  three_star
  two_star
  one_star

Book ranking:
  rating
  ranking_score
  overall_rank
  favorite_count
  avg_rating
  review_count

Author ranking:
  total_books
  total_views
  avg_rating
  total_favorites
  author_score
  overall_rank

Review list:
  helpful_count
```

Keep IDs, view counts, chapter order, rating submitted by a user, and review
rating as JSON integers where the existing response models expect integers.
Dates remain ISO-8601-compatible strings.

Valid no-review stats response:

```json
{
  "code": 200,
  "message": "Success",
  "data": [
    {
      "total_reviews": "0",
      "average_rating": "0.0",
      "five_star": "0",
      "four_star": "0",
      "three_star": "0",
      "two_star": "0",
      "one_star": "0"
    }
  ]
}
```

For list endpoints, an empty result must be a successful envelope with
`data: []`. Do not pad rankings with fake rows; Flutter has dedicated empty and
insufficient-data states.

## 18.5 `detailBook` success contract

On a valid book/chapter, `data` must contain one detail object. Important exact
keys include:

```text
book_id
title
url
image_url
excerpt
views
status
rating
author_id
author_name
author_biography
category_id
category_name
created_at
updated_at
total_chapters
total_reviews
is_subscribed
is_favorited
chapters
current_chapter
```

For a guest:

```json
{
  "is_subscribed": false,
  "is_favorited": false
}
```

For a valid authenticated user, calculate those two values for the token user.
If this response is cached, do not let authenticated flags leak across users;
either cache only public book data and merge flags afterward, or vary the cache
by authenticated identity.

## 19. Authentication endpoints and phone-number privacy

`POST /auth/login` and `POST /auth/register` are unauthenticated endpoints, but
they are not anonymous content APIs. They need validation, rate limiting, and
credential abuse protection rather than `requireAuth`.

Current login body:

```json
{
  "email": "reader@example.com",
  "password": "...",
  "token_fcm": "..."
}
```

Current login success parsing expects the response `data` to contain key/value
items. Preserve this shape unless Flutter is migrated at the same time:

```json
{
  "code": 200,
  "message": "Login successful",
  "data": [
    { "key": "token", "value": "<jwt>" },
    {
      "key": "user",
      "value": {
        "id": 7,
        "username": "reader",
        "email": "reader@example.com",
        "isAds": "on"
      }
    }
  ]
}
```

The JWT must contain or resolve to the stable user identity needed by all
private routes. Do not require a separate client `userId` for authentication.

Current registration body:

```json
{
  "username": "reader",
  "email": "reader@example.com",
  "password": "...",
  "token_fcm": "",
  "click_send_name": "",
  "phone_number": "0987654321",
  "click_send_key": ""
}
```

The Flutter registration and edit-profile screens no longer collect phone
numbers. `0987654321` is a compatibility sentinel, not user data.

Backend requirements:

* Make `phone_number` optional at the validation/domain layer.
* Recognize `0987654321` as "no phone supplied".
* Do not validate it as the user's real phone.
* Do not send SMS or notifications to it.
* Do not use it as an identity, lookup key, recovery factor, or fraud signal.
* Do not apply a uniqueness constraint to the sentinel.
* Prefer normalizing it to `NULL` on new registration if the schema permits.
* On profile update, ignore the sentinel instead of overwriting an existing
  value with fake data. Any cleanup of historical real phone numbers should be
  handled as an explicit privacy/data-retention migration.
* Continue accepting requests where `phone_number` is absent so a future mobile
  release can stop sending the compatibility field entirely.
* Treat empty `click_send_name`, `click_send_key`, and `token_fcm` as absent.

Do not ask the Flutter team to restore a phone input merely because the legacy
database column is non-nullable. Fix the backend validation/schema boundary.

## 20. Error handling compatibility and status semantics

Use real HTTP status codes and keep the JSON envelope `code` aligned with the
HTTP status.

```text
2xx -> success
400 -> invalid/missing content parameter
401 -> missing/invalid auth on private endpoint
403 -> authenticated but not allowed to access another user's resource
404 -> content/resource does not exist
409 -> conflict such as duplicate account/review where applicable
429 -> rate limited
5xx -> server failure
```

Never return HTTP 200 with `code: 401` or `code: 500`.

Known Flutter limitation: several legacy services currently check only
`response.code != null` instead of checking the 2xx range. Therefore:

* Public requests produced by the app must be validated carefully so valid IDs
  never fall through to an error envelope unexpectedly.
* Successful `detailBook` and review-stats responses must never contain empty
  data.
* Backend must still return correct 4xx/5xx semantics; do not hide real failures
  with fake 200 responses. The client-side status check should be hardened in a
  separate Flutter cleanup.

For all errors, return JSON—not HTML—and never include stack traces, SQL text,
JWTs, passwords, or internal infrastructure details.

## 21. Public endpoint operational safeguards

Making content readable without authentication increases anonymous traffic.
Add safeguards that do not require an account:

* Per-IP/device-appropriate rate limiting with limits high enough for normal
  reading and pagination.
* Maximum `limit` bounds to prevent unbounded queries.
* Parameterized queries and strict numeric validation for content IDs.
* Timeouts for upstream/database calls.
* Cache public lists, trending, rankings, and immutable chapter content where
  safe.
* Do not cache or share user-specific favorite/subscription flags.
* Structured logs and metrics for 4xx/5xx rates without logging tokens or
  personal content.

## 22. Backend implementation checklist for the current mobile build

```text
[ ] Clean install can call all section 18.2 routes with `Authorization: Bearer `.
[ ] Public GET routes degrade missing/empty/invalid JWT to req.user=null.
[ ] Private routes require a valid JWT and scope ownership to req.user.id.
[ ] `detailBook` returns chapter content to guest and false account flags.
[ ] `reviews/stats` returns one zero object when there are no reviews.
[ ] Empty list endpoints return 200 with data: [].
[ ] Aggregate numeric-looking fields preserve the string types in section 18.4.
[ ] Registration/profile do not require or collect a real phone number.
[ ] The phone sentinel is never treated as unique or used for SMS.
[ ] Current numeric `active_only` values remain temporarily compatible.
[ ] Logged-in favorites/follow/history/notes/reviews/profile still work.
[ ] Invalid ownership attempts return 403/404 without leaking private data.
[ ] Public endpoint rate limits and maximum page sizes are in place.
[ ] Integration tests run against the same deployed base URL used by Flutter.
```

## 23. Required compatibility test cases

Add these tests in addition to section 14.

### 23.1 Guest versus authenticated detail flags

```text
Given a book favorited/subscribed by user A:

GET detailBook as guest
  -> 200
  -> chapter content is present
  -> is_favorited=false
  -> is_subscribed=false

GET detailBook with user A token
  -> 200
  -> is_favorited=true
  -> is_subscribed=true

GET detailBook with user B token
  -> flags reflect user B only
```

This test must also cover cache isolation.

### 23.2 Empty content responses

```text
Search with no matches       -> 200, data=[]
Books ranking with no rows   -> 200, data=[]
Author ranking with no rows  -> 200, data=[]
Review list with no rows     -> 200, data=[]
Review stats with no rows    -> 200, data=[zero stats object]
```

### 23.3 JSON type compatibility

Serialize a representative response for books, reviews, review stats, and both
ranking endpoints. Assert every field listed in section 18.4 is a JSON string,
not a JSON number.

### 23.4 Phone privacy compatibility

```text
Register with phone_number omitted
  -> success when other fields are valid

Register with phone_number="0987654321"
  -> success
  -> normalized as no phone
  -> no SMS side effect

Register a second account with the same sentinel
  -> success; no uniqueness conflict

Update profile with phone_number="0987654321"
  -> username/email update succeeds
  -> placeholder is not stored as a real phone
```

### 23.5 Temporary subscriptions query compatibility

```text
active_only=true -> active subscriptions
active_only=1    -> active subscriptions
active_only=10   -> active subscriptions (current Flutter request)
active_only=false or 0 -> behavior defined by the existing endpoint
```

### 23.6 Private ownership tests

For favorites, subscriptions, notifications, history, notes, reviews, profile,
and account deletion:

```text
No token          -> 401
Invalid token     -> 401
Valid owner token -> existing success behavior
User A token with user B resource/id in body -> 403 or 404, never success
```

### 23.7 Login response regression test

Verify that login returns the key/value data structure in section 19 and that
the JWT can immediately call all authenticated endpoints. This catches a login
that appears successful but does not populate Flutter's `authToken` or `userId`.
