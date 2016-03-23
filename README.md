# Web application consuming try-one Mysterious Ruby Backend

First, assemble try-one backend on `localhost:3000`.

Application itself runs at `index.html`.

Jasmine specs live in `jasmine/spec/SpecHelper.html`. They use mock ajax data from coffee-compiled `requests.js` and `fixtures.js` painfully added manually from `index.html` _work-space..templates_ section. They also should be manually minified before adding. What a shame. Sorry, could make through cross-origin-allowances only this way.