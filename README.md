# Law-Connect

Connect middleware for Law.

## Purpose
Law-Connect provides a piece of Connect middleware to route HTTP requests
to Law services. It provides configurable routing on URI path and HTTP
method, as well as a `resource` helper which expands into standard CRUD
routes (modeled after the Rails `resources`[1]).

[1] http://guides.rubyonrails.org/routing.html#crud-verbs-and-actions

## Usage
Law-Connect provides a standard Connect middleware.We expect the user to have a
collection of _already-configured_ Law services (`services`), a collection of
route definitions (`routeDefs`), and an optional object (`options` )of parameters
that control how error information is exposed in responses.

## Lifecycle
Law-Connect simply provides a constructor for a piece of Connect middleware.
It expects a fully wired-up `services` object (the output of `law.create`).

## Example

```js
connect = require 'connect'
lawAdapter = require 'law-connect'

// Given a Connect application...
app = connect()

// The `connect.json`, `connect.urlencoded`, `connect.multipart` middleware must be `use`'d before Law-Connect
app.use connect.json() // required!
app.use connect.urlencoded() // required!
app.use connect.multipart() // required!

// Given a wired-up `services` object, e.g. the result of:
//   services = law.create {services, jargon, policy}
routeDefs = load './routeDefs'

// Hide most Error information in responses
options =
  includeDetails: false
  includeStack: false

// Apply the middleware!
app.use lawAdapter({services, routeDefs, options})
```

## Error handling and HTTP status codes

Errors are passed in the first callback argument, according to the Node convention
used within Law. Errors within Law are subtypes of a `LawError` subtype of `Error`,
created with the `tea-error` library. Thus `LawError` and subtypes enrich `Error`
with a `toJSON` method and the ability to construct instances with additional
properties containing information about the error context.

By default, all error response bodies include:
- The error `message`
- All custom, service-specific properties attached to the `LawError` instance.
- The error stack trace (`stack`)

If a Law service returns an error, the HTTP response presently defaults to using a
status code of `500 Internal Server Error`.

If there was no Law service that could be matched with the request, the middleware
will return a `501 Not Implemented` HTTP response.

Otherwise, the default response is `200 OK`. Specific HTTP codes can be specified by
Law services by including a `statusCode` property in the `results` argument of the
callback, which will always be treated as metadata (and thus _not_ included in the
response body).


## Configuration

### Service Definitions
Regular route definitions are of the form:

```js
[
  {
    path: '/something'
    method: 'get'
    serviceName: 'indexThings'
  }
  {
    path: '/something/:id'
    method: 'get'
    serviceName: 'showThing'
  }
]
```
The values of the `serviceName` property should resolve to a wired-up Law service
when the adapter is constructed. If not, a default `noService` service will respond
with a `501` error indicating that no service is implemented.

The resource syntax uses the format:

```js
[
  {
    resource: 'photos'
    prefix: 'api'
    id: 'special_field'
  }
]
```
The presence of the `resource` key indicates that the route definition should be automatically expanded
into several regular route definitions. The value of `resource` should be the collection name (plural).

The `prefix` and `id` keys are optional.  `prefix` will namespace all of the routes under the provided string.  `id` configures what named argument will be passed in for the instance routes.

Regular route definitions and `resource` route definitions can be freely interspersed within
a single route definition array, and `resources` definitions will be expanded in-place.

### Options

Optional configuration can be passed via the `options` property of the arguments
object. The current properties, which all default to `true`, are:

- `includeDetails`: Include context details attached as properties to any subtypes of `LawError`.
- `includeMessage`: Include the `Error.message` property.
- `includeStack`: Include the stack trace via the `Error.stack` property.

## License

(MIT License)

Copyright (c) 2013 Torchlight Software <info@torchlightsoftware.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
