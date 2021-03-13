'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "c8f9a49b3d1f0070662961fdd970634d",
"index.html": "73bb0ec75d50b979ab66705aade42b51",
"/": "73bb0ec75d50b979ab66705aade42b51",
"main.dart.js": "ec4e82c2d638163abcf27983581c737b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "7e8765566b298722257e68e3e52fee4f",
"assets/background/4.jpg": "4f46910deaf2d73a273203317e9e04d7",
"assets/background/5.jpg": "7c6d44b4718956b8c8351ac1f41f01ee",
"assets/background/6.jpg": "623c58eb3559f12336a16b5480e005ed",
"assets/background/2.jpg": "c1ee28cdee283c91fc3a482086cfd861",
"assets/background/3.jpg": "1b0389533ec9c49f15f13ec473f94b9e",
"assets/background/1.jpg": "1821822266d4ba2bbb25746b10084fc6",
"assets/AssetManifest.json": "9ba4a437a1539eded97a9e79358dadba",
"assets/NOTICES": "aeb5fd2e16b7199cf54d084c1034985a",
"assets/FontManifest.json": "28a01711e738bffb1b5a3dcd8a1ba5c1",
"assets/icons/highlight.svg": "ed3c5e7604938f6bba048daf8843f68d",
"assets/icons/todo.svg": "7c80f1701027b7b48444d44f2ec41cb0",
"assets/icons/home.svg": "3823ba77337b21b7e9b405e4637a6162",
"assets/icons/emptyBacklog.svg": "5786d259b046f4ce3ceb11270ac1e243",
"assets/icons/logout.svg": "f6a31c77116f0f75a70acf6b39afeeb2",
"assets/icons/streak.svg": "a5d2425deea1e15b60555014c1a253b5",
"assets/icons/emptyRadio.svg": "d80ca43f49e67f15a0e80dd5234325c6",
"assets/icons/checkDone.svg": "6e131a6bc2868aeb4c0f99b90bcbac19",
"assets/icons/alarm-grey.svg": "7de3e2cb1db0466fb1764c1ea12661c1",
"assets/icons/selectedRadio.svg": "99dcfb5534c6af0b263afe43b9ad459d",
"assets/icons/settings.svg": "1fcb4fed84cd4cb027a9570a0aa04563",
"assets/icons/fillChecklist.svg": "ff4e4419cb8677c10509134a57190513",
"assets/icons/bell.svg": "cfef63fba1c7f80ed5885b2dfaeebfbd",
"assets/icons/check.svg": "61a15dfd585b62c8fa8fa933cd19aab7",
"assets/icons/add.svg": "90b740c213d2b2db810d967d59f89069",
"assets/icons/close.svg": "2f5c2d9978cd8442eec300fe9ad9141f",
"assets/icons/defaultAvatar.svg": "68c365ec9561e64d53abb2065bbfa896",
"assets/icons/google.svg": "54ad34190e640aa0cc41554de48965e4",
"assets/icons/more.svg": "b27a50fa23442c5324b9534642f93d7a",
"assets/icons/trash.svg": "1add71f540b920a49dd26e3a840e3a71",
"assets/icons/checklist.svg": "c550f5e882a10060b10058e349ce9722",
"assets/icons/edit.svg": "a4a2c93772395a52e98b3033086e5dc5",
"assets/icons/iconDone.svg": "a2454f616b99d7a76352734cba230288",
"assets/icons/profile.svg": "7d1dd686654b57c92a8ef3f1adb34993",
"assets/icons/arrowUpRight.svg": "722284af9f5ba54a9540284e3c7d7ba6",
"assets/icons/logo.svg": "1c1f59fc9d1c78abd13506eb22080a2f",
"assets/icons/emptyChecklist.svg": "f10881d9373c71ff77e83f7d675f618c",
"assets/icons/done.svg": "c550f5e882a10060b10058e349ce9722",
"assets/icons/menu.svg": "e4da1aeaddc6accbe4171cd0106f2968",
"assets/icons/alarm.svg": "8568baaf814ff005fb2801fb5d3f4a20",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/packages/fluttertoast/assets/toastify.js": "8f5ac78dd0b9b5c9959ea1ade77f68ae",
"assets/packages/fluttertoast/assets/toastify.css": "8beb4c67569fb90146861e66d94163d7",
"assets/fonts/Inter-Bold.ttf": "c73899dff65a846e3d8423b04cb041ec",
"assets/fonts/Inter-Regular.ttf": "56786aa1952d68dada47626302897eae",
"assets/fonts/Inter-ExtraBold.ttf": "c88d8bbbf91fb59ecb13ac80d7bd56eb",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/fonts/Inter-SemiBold.ttf": "65cbb7515961a8f823110c2a612fd0d9",
"assets/assets/background/4.jpg": "4f46910deaf2d73a273203317e9e04d7",
"assets/assets/background/5.jpg": "7c6d44b4718956b8c8351ac1f41f01ee",
"assets/assets/background/6.jpg": "623c58eb3559f12336a16b5480e005ed",
"assets/assets/background/2.jpg": "c1ee28cdee283c91fc3a482086cfd861",
"assets/assets/background/3.jpg": "1b0389533ec9c49f15f13ec473f94b9e",
"assets/assets/background/1.jpg": "1821822266d4ba2bbb25746b10084fc6",
"assets/assets/icons/highlight.svg": "ed3c5e7604938f6bba048daf8843f68d",
"assets/assets/icons/todo.svg": "7c80f1701027b7b48444d44f2ec41cb0",
"assets/assets/icons/home.svg": "3823ba77337b21b7e9b405e4637a6162",
"assets/assets/icons/emptyBacklog.svg": "5786d259b046f4ce3ceb11270ac1e243",
"assets/assets/icons/logout.svg": "f6a31c77116f0f75a70acf6b39afeeb2",
"assets/assets/icons/streak.svg": "a5d2425deea1e15b60555014c1a253b5",
"assets/assets/icons/emptyRadio.svg": "d80ca43f49e67f15a0e80dd5234325c6",
"assets/assets/icons/checkDone.svg": "6e131a6bc2868aeb4c0f99b90bcbac19",
"assets/assets/icons/alarm-grey.svg": "7de3e2cb1db0466fb1764c1ea12661c1",
"assets/assets/icons/selectedRadio.svg": "99dcfb5534c6af0b263afe43b9ad459d",
"assets/assets/icons/settings.svg": "1fcb4fed84cd4cb027a9570a0aa04563",
"assets/assets/icons/fillChecklist.svg": "ff4e4419cb8677c10509134a57190513",
"assets/assets/icons/bell.svg": "cfef63fba1c7f80ed5885b2dfaeebfbd",
"assets/assets/icons/check.svg": "61a15dfd585b62c8fa8fa933cd19aab7",
"assets/assets/icons/add.svg": "90b740c213d2b2db810d967d59f89069",
"assets/assets/icons/close.svg": "2f5c2d9978cd8442eec300fe9ad9141f",
"assets/assets/icons/defaultAvatar.svg": "68c365ec9561e64d53abb2065bbfa896",
"assets/assets/icons/google.svg": "54ad34190e640aa0cc41554de48965e4",
"assets/assets/icons/more.svg": "b27a50fa23442c5324b9534642f93d7a",
"assets/assets/icons/trash.svg": "1add71f540b920a49dd26e3a840e3a71",
"assets/assets/icons/checklist.svg": "c550f5e882a10060b10058e349ce9722",
"assets/assets/icons/edit.svg": "a4a2c93772395a52e98b3033086e5dc5",
"assets/assets/icons/iconDone.svg": "a2454f616b99d7a76352734cba230288",
"assets/assets/icons/profile.svg": "7d1dd686654b57c92a8ef3f1adb34993",
"assets/assets/icons/arrowUpRight.svg": "722284af9f5ba54a9540284e3c7d7ba6",
"assets/assets/icons/logo.svg": "1c1f59fc9d1c78abd13506eb22080a2f",
"assets/assets/icons/emptyChecklist.svg": "f10881d9373c71ff77e83f7d675f618c",
"assets/assets/icons/done.svg": "c550f5e882a10060b10058e349ce9722",
"assets/assets/icons/menu.svg": "e4da1aeaddc6accbe4171cd0106f2968",
"assets/assets/icons/alarm.svg": "8568baaf814ff005fb2801fb5d3f4a20",
"assets/assets/fonts/Inter-Bold.ttf": "c73899dff65a846e3d8423b04cb041ec",
"assets/assets/fonts/Inter-Regular.ttf": "56786aa1952d68dada47626302897eae",
"assets/assets/fonts/Inter-ExtraBold.ttf": "c88d8bbbf91fb59ecb13ac80d7bd56eb",
"assets/assets/fonts/Inter-SemiBold.ttf": "65cbb7515961a8f823110c2a612fd0d9"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
