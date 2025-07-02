'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"manifest.json": "e5eef7d3f1909ec0f6b2a68b3099e8c6",
"main.dart.js": "fb03e26e813f8270d0ff9335bf605888",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"index.html": "7766680a2f9d55b94967a46dda5dc616",
"/": "7766680a2f9d55b94967a46dda5dc616",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "4769f3245a24c1fa9965f113ea85ec2a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "ee29178528a57980ca8058fe2f8440a7",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "3fb753537ad4cde1a1e336f67f57c014",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/AssetManifest.bin.json": "74012c392e196bb72d6187b00d11e563",
"assets/AssetManifest.bin": "653ef7a7073a7318d1d30b5423a0f3d7",
"assets/NOTICES": "9605b40538e22d38d01b0e8248b7e196",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/assets/icons/icoFB.png": "3a1ffb1d22d5a9a5269d39ad7512a276",
"assets/assets/icons/ico_star.png": "ad4834f2c9d299ee4877537743e24851",
"assets/assets/icons/ico_oval_top.png": "ae0d004e11c48a3ac85296c8e6201ae3",
"assets/assets/icons/icoRectangleWhite.png": "688ed9a6d12f308b02559c7403fcb530",
"assets/assets/icons/ico_crown.png": "ce03e4ad4a77a9ef1c4624766bc9ebc0",
"assets/assets/icons/ico_home.svg": "a19577d99655195471814a5a4321166d",
"assets/assets/icons/icoGG.png": "31eeb3fa231c08fb4f7a7a24ed206e63",
"assets/assets/icons/ico_rank.png": "41ac3fc3ef5a52f68d095d22dfdf5536",
"assets/assets/icons/ico_oval_bottom.png": "cc10551e0fd51b590cf25a0138cda3ec",
"assets/assets/icons/icoLocation.png": "17367ff12fed020e0c1d28329c63228e",
"assets/assets/icons/ico_history.png": "4d1efebdc8e3987512568e2d5b435788",
"assets/assets/icons/ico_star.svg": "6373eaa6f3ec5b8d98305ffdf970663a",
"assets/assets/icons/ico_book_follow.png": "bd19e1ab7f356ca9b48442e5aeb7a3de",
"assets/assets/icons/icon_empty_data.svg": "ea903ad11927b14a92b7c6150ae234ca",
"assets/assets/icons/icoRectangleBlue.png": "500bed4bfe119a4bec36f4abf4e1042b",
"assets/assets/icons/icon_app.png": "067f7b976d8f96a219bffd4cc2f20315",
"assets/assets/translations/en-US.json": "9836d0ef2503b44cd8a6c1ed808dfa44",
"assets/assets/translations/vi-VN.json": "0c4f282c3cf2ec370ccfa6c6368af4b2",
"assets/assets/images/book_mock.png": "078af12359fadec17be6545df3e247a0",
"assets/assets/images/rank_1.png": "c497418a3d2c6b79f01f9b8de9c80fb1",
"assets/assets/images/rank_3.png": "389ef463ee364b4e91e35aa4a68a8921",
"assets/assets/images/slide3.png": "83acaacb40fd3bdb8d4f35501839ddf9",
"assets/assets/images/background_splash.png": "ccac657620a3c85d063b004281626fbb",
"assets/assets/images/harry_potter_cover.jpg": "9fb4817549d28a7aba6abd2081e42a58",
"assets/assets/images/slide1.png": "1f50b3a748a72dbaa5c3f97c9d7306e5",
"assets/assets/images/slide2.png": "65a8345dd3bfab8cbf1962f4e24f0e2b",
"assets/assets/images/rank_2.png": "aee0f46f6b24afe951b00b0e7d25f01e",
"assets/assets/images/default_image.png": "4d872908a1c82beb13d3edb96c5d7014",
"assets/assets/images/harry_potter_2.jpg": "fa6f97a895aa69b52f13b2f3002e13ff",
"assets/assets/images/avatar.jpg": "0f2afde20568ac0b1ea5cecd922f3c59",
"assets/assets/images/circle_splash.png": "15cbbb8be34aa788ef11c18bd77bcc55",
"assets/AssetManifest.json": "8af6fcd2367c19d3690c6f745f10a957",
"assets/fonts/MaterialIcons-Regular.otf": "556f0a060578e82b12a918319d57debc",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "ed4a3fdfc175a220dec0a3cdb3587870",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "19753eb5f4ced6c76b16a9127df67828",
"flutter_bootstrap.js": "e4aa97f924670d4fb6753f719a253994",
"version.json": "40562a685721cbbfb65c5476eb59530a"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
