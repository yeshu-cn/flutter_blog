'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"index.html": "ed916061b07454482f5c273191e87e56",
"/": "ed916061b07454482f5c273191e87e56",
"main.dart.js": "d21f51b7b9ea3b783684ccbce3ccb8b6",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "3fb3e90e3520e4005da1a01da2918d72",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"images/1589782578000/1.jpg": "4f6e40ed7eb00d5c56e96906a6777ba0",
"images/1642147329000/mock_app.png": "61f3d7905165b523ce97b8855c945d56",
"images/1642147329000/4.jpg": "37cdfad3fbc66601b2e95705905576dd",
"images/1642147329000/5.jpg": "04fb6e33bb2e39cd551a7fb558a9368c",
"images/1640275874000/1.jpg": "d0d99537c2eeca0b6bd189c7d23832a4",
"images/1604491818000/16027468122796.jpg": "d4847ee3b52df48ffebdb381971bf208",
"images/1604491818000/16023002460668.jpg": "c7e263bb75bf11c36af35c38c19f8006",
"images/1604491818000/16033478755790.jpg": "ae8a5e0be576c96c697586f14f52d9c6",
"images/1604491818000/16027442758485.jpg": "efc66d293522c8c203ed775b5593a4fd",
"images/1604491818000/16033342202225.jpg": "e773cae2148a7cf9a87a4a989e6db2bb",
"images/1604491818000/16027476999338.jpg": "b5799dd345099a58bdc9c4c95976423c",
"images/1604491818000/16033341946477.jpg": "e773cae2148a7cf9a87a4a989e6db2bb",
"images/1604491818000/16027469415956.jpg": "eba66583ebe0812d7a2c1d861cd03b21",
"images/1604491818000/16023002606430.jpg": "6bd158f84f7af667c601d2c6f7c3c9b5",
"images/1604491818000/16027463127357.jpg": "52fd12f691b8e6dcc25c2fa9a37c5b82",
"images/1604491818000/16027462985387.jpg": "433622c79d327590b28d9eadd97046a3",
"images/1604491818000/16027477091261.jpg": "21ce17f8b7f740f1df3722249bddb3ec",
"images/1604491818000/16027329552278.jpg": "004a3e667c0296752274013d8b4f553d",
"images/1604491818000/16004001423590.jpg": "813a1b2b9a205d0975af02284fd943cc",
"images/1597741125000/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202020-08-17%20%E4%B8%8B%E5%8D%882.41.56.png": "2e5fbe2b68a34dff0d0d75f5f891f451",
"images/1597741125000/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202020-08-17%20%E4%B8%8B%E5%8D%883.26.53.png": "116c4db9099345a1162a57f714b380fa",
"images/1597741125000/15973121341575.jpg": "defcef7b871b6de711d86a9e49a89704",
"images/1597741125000/15973952187597.jpg": "ce6d71f21c308a18bc9c500c9a98f890",
"images/1597741125000/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202020-08-13%20%E4%B8%8B%E5%8D%887.54.54.png": "e3d353ccdc3c3995d0af7d2f8ab04ecd",
"images/1597741125000/15973953446177.jpg": "24822bc8a2da01ff6b56fc7b47978c3b",
"images/1597741125000/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202020-08-17%20%E4%B8%8B%E5%8D%882.43.40.png": "04d6a1ca5c05b1bc68b1ddf974791a3b",
"images/1597741125000/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202020-08-17%20%E4%B8%8B%E5%8D%882.44.21.png": "6121cb89850a97cf31a078b493404dea",
"images/1597741125000/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202020-08-13%20%E4%B8%8B%E5%8D%885.48.26.png": "77f931d0f9d448e1dd03ddeb90f2030e",
"images/1597741125000/15975665211545.jpg": "98d38cd23f8b9f145b56362094da3a78",
"images/1597741125000/15973944410542.jpg": "ce6d71f21c308a18bc9c500c9a98f890",
"images/1594191792000/15941778752001.jpg": "21b1115b36112ac5c6c0bd02d9e44be7",
"images/1594191792000/15941779248052.jpg": "a43b707996dc005fdaef2482642363c5",
"version.json": "ce653a430d279d6b8f4a560dea3033c0",
"assets/shaders/ink_sparkle.frag": "2e20de64bc8fe44f4ba31b8dc3a825bc",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "2d1fadb2a154a577adf6a67ea1864f31",
"assets/AssetManifest.json": "431ce12ae2c90df86751dde8308d51f6",
"assets/assets/api/posts.json": "0c78ae918c82f82c4b8fad561beedfbb",
"assets/assets/api/categories.json": "9f691385b0a61e9b6e7fa08833d00e98",
"assets/assets/post/1457376196000.json": "db20f5fe57a6ba2814db32f9a3e16c4d",
"assets/assets/post/1510912692000.json": "7730645c93c8ad889853dc153354d38b",
"assets/assets/post/1668634882000.json": "1e8e09faa48e024de44b75b74ae11526",
"assets/assets/post/1473844298000.json": "63a0f65484d1067f2e4ec3a5b1125001",
"assets/assets/post/1463444702000.json": "a365ecfaa8ea9f2f0d9be626225aab8f",
"assets/assets/post/1442347941000.json": "1c504115251d29a9443e88df712f9259",
"assets/assets/post/1459903411000.json": "e18040891bbceeeb6b84fb745ea482e0",
"assets/assets/post/1597741125000.json": "1d16e3fee620d23a2fdd60f806e35238",
"assets/assets/post/1459281351000.json": "b721bddb19124bd5a4a287dad367d692",
"assets/assets/post/1463010286000.json": "282e27cb0dd875045c6b281561f531c0",
"assets/assets/post/1437524482000.json": "48b44b1602d456160877ade360115367",
"assets/assets/post/1528117459000.json": "9603d0e7a8291485dd68fd63e9663165",
"assets/assets/post/1442110547000.json": "cd2a1fa1de6a0f4f050f5db834575b79",
"assets/assets/post/1442125924000.json": "fc82c8090c79831fb3f6a3d138c6e7b3",
"assets/assets/post/1436228089000.json": "7e034c6bb3370348dd7d67576dcc5d43",
"assets/assets/post/1461107773000.json": "0627feb9c8af09f68efb66bb466b0156",
"assets/assets/post/1438185795000.json": "4f3ac63ab26560842e456be15249d764",
"assets/assets/post/1527838778000.json": "d5dac8dbcde5da4e8bf89f306b7557f2",
"assets/assets/post/1591670827000.json": "ee759dee3e42b249a79feaf372f5a8f7",
"assets/assets/post/1507716054000.json": "ec387dec1149f55951839b09a4ee9a59",
"assets/assets/post/1439622740000.json": "91513b5e20318861348b97d5e568d301",
"assets/assets/post/1588237475000.json": "cfe3f65382c370e8d421fae23eb1214a",
"assets/assets/post/1460072817000.json": "f6cab83f40a7885d4ea40399d025e2a9",
"assets/assets/post/1476007568000.json": "889d71e1192e0361973d75cbcff92e0a",
"assets/assets/post/1460336071000.json": "c96b6a11a1ffd48d912ea02be227d66b",
"assets/assets/post/1432778882000.json": "a8c658ba972e4aeba71c9ad6d764e0e8",
"assets/assets/post/1421707000000.json": "efccd8e8247328431a283efcf7272134",
"assets/assets/post/1511256045000.json": "a8750d0a07cba4bb8469f52fdbd076f9",
"assets/assets/post/1535426547000.json": "30a9ee5cc3489f7df1cf69c7e3e7af63",
"assets/assets/post/1470355451000.json": "58c5c48f54da7eedf91c96eb2ac71c4e",
"assets/assets/post/1441526647000.json": "ebe07b729913a46968cd9efbfa28da60",
"assets/assets/post/1437603990000.json": "93f6cd3b0722a097054d0b3eac67ad06",
"assets/assets/post/1427998496000.json": "3d61c990aa4141d233b69635908c5c8a",
"assets/assets/post/1504581660000.json": "cc57a825269ffdcb8fbba88e85c99a8c",
"assets/assets/post/1457464077000.json": "043cc618147a66b9c514cc2f28b29df8",
"assets/assets/post/1587436340000.json": "0d52458127fd2472b1f3c1b373034042",
"assets/assets/post/1594191792000.json": "04cf8f508c5de55ce00f880140f489e4",
"assets/assets/post/1464048041000.json": "91b48deb9f892af4f3bf9bb302bb5e42",
"assets/assets/post/1517564692000.json": "926ec286fa6c330af15f503b5fe42ee3",
"assets/assets/post/1589773000000.json": "5790a24cbd6148d96c2ac84308aacfca",
"assets/assets/post/1460949601000.json": "e4307ab10e921e6ca7d42fe08421e2cc",
"assets/assets/post/1464580271000.json": "89f94cb7cb333d777697c928fa8a486d",
"assets/assets/post/1433272977000.json": "ebac7b8b82fa47e4058fb306eda9daad",
"assets/assets/post/1457495998000.json": "3b0f999051622037d4ee64d1a379d796",
"assets/assets/post/1457454611000.json": "557a3b86a6f585ba22e01a0631731e1e",
"assets/assets/post/1442101042000.json": "a09ccadace48e5f827661cbdd48e464c",
"assets/assets/post/1475142107000.json": "95f1ac9508f83ee2fc8a6f0f8b52a77b",
"assets/assets/post/1604491818000.json": "b36877c697d4dbe017d6e4ab6a7b1328",
"assets/assets/post/1511431427000.json": "dabc86b363a9db3ad201da85bfd464d5",
"assets/assets/post/1588043108000.json": "e598981162dad080baddf4780d97de37",
"assets/assets/post/1474625005000.json": "184b7b10d510d864eeba423586573bd2",
"assets/assets/post/1527665524000.json": "b2fe28189b91507aa2dbd1a5fbd948a2",
"assets/assets/post/1473680950000.json": "5bf91f6fe867cfe1ba5770664bbc6db9",
"assets/assets/post/1463425661000.json": "9dca5b48712428ee51aa8331c491a7e1",
"assets/assets/post/1510301183000.json": "c7895d77cf48821f25a67a8533d7d58b",
"assets/assets/post/1474275623000.json": "34ff1c23124184515c6aa1ee62c291b7",
"assets/assets/post/1553504766000.json": "538dd4e0f6c282f9b915f5569d1fe08b",
"assets/assets/post/1427680041000.json": "ddbf97e2a31ed8c0479a77ef5ad06ae6",
"assets/assets/post/1473845001000.json": "6f814b532c98d342b3497e811c706daa",
"assets/assets/post/1475055465000.json": "7bbc120565eccbb09018df309304485f",
"assets/assets/post/1459989043000.json": "c13984315d734693ce2acf19ec292eb7",
"assets/assets/post/1418508638000.json": "ebf6e02bc98a894670cbe8386574db76",
"assets/assets/post/1464052890000.json": "59099ae3e0675c755116d11dda977cee",
"assets/assets/post/1418582350000.json": "e03fef9e14cd492c81b7ef08af7a1bd8",
"assets/assets/post/1433373964000.json": "f9ac6011fca43d662a55809f4e043aae",
"assets/assets/post/1473734519000.json": "f847167834a69914c2ea89eccb13ce87",
"assets/assets/post/1640275874000.json": "a5313ba7efbc1a3504ce9dbaeddd33d1",
"assets/assets/post/1444369037000.json": "368a01ad976e5d50ff0358fb6124a93f",
"assets/assets/post/1428604314000.json": "451e8b274999328b7618119f9ae50f8c",
"assets/assets/post/1559272557000.json": "585d26a0f58e774927e259a00bb86d73",
"assets/assets/post/1532505738000.json": "d2eba1d65767f8195acffb7197773154",
"assets/assets/post/1476094466000.json": "74ed302ae380a4852957a1aa70580332",
"assets/assets/post/1417026916000.json": "a91843e85f0b0450cddf7ddb3f6d4d08",
"assets/assets/post/1459454237000.json": "d3c649302ed5427e07e6cc64d60d0108",
"assets/assets/post/1597114405000.json": "5c2479eb94cdc0ae7d8c3de809d268f3",
"assets/assets/post/1642147329000.json": "97449b7da48f5c68681a8932ef2a6667",
"assets/assets/post/1491038389000.json": "4a0e78b799e8e0e0644f1b9e40d72ad2",
"assets/assets/post/1445922309000.json": "c3c27e9307af92f99cbffbb7fa03ac6e",
"assets/assets/post/1457462911000.json": "666d7e09af042eb06ab7df8fb7a21619",
"assets/assets/post/1476327463000.json": "c734f40554d2395dbf9cabf7e7432c96",
"assets/assets/post/1438044425000.json": "50cb1afbdd8a59762151541e988e2b3b",
"assets/assets/post/1441525439000.json": "19834b1ac448b6b01bff574a4dc5f638",
"assets/assets/post/1470355882000.json": "e40568d49a8bbffad4efb79d9d3a9fb5",
"assets/assets/post/1461278086000.json": "4faa952b13a74e599440989945021629",
"assets/assets/post/1587523236000.json": "55fca0bacbe7b712911ee966b450afe5",
"assets/assets/post/1536318249000.json": "8c31ac1d272c2a22c9c1c0c4a129b510",
"assets/assets/post/1540192367000.json": "9b4a0ae00df4eda93dbb0c60de80a5a0",
"assets/assets/post/1465804544000.json": "65bc3407d34bce332aa15bf27589e6b1",
"assets/assets/post/1488543388000.json": "a054a3643bfa8c756419ec0b74b02928",
"assets/assets/post/1659925506000.json": "1a69fca73d107cc4311724b678d1c43d",
"assets/assets/post/1441526768000.json": "55a4cd3f08d38cdc22ac3447ab4c55a4",
"assets/assets/post/1474183237000.json": "f8936ed26aa92f00358275a8ecd55b07",
"assets/assets/post/1474451414000.json": "7df2b36780b818d3eb426c72cdd7bbf6",
"assets/assets/post/1474340730000.json": "a401f79f1bca9a99cecb3753f5283002",
"assets/assets/post/1442992501000.json": "4f116a8972ccccd60a2bbee65af3ab5a",
"assets/assets/post/1441761936000.json": "51edbd2fddaeeea756a7b237c2877bd9",
"assets/assets/post/1432513559000.json": "17ba6d25bbcd5a68c7be8fcc187ad8e6",
"assets/assets/post/1604287977000.json": "81a81e592e57832adfeca273aaa3aa0b",
"assets/assets/post/1589782578000.json": "097978fa717052b62394346469b7ef97",
"assets/assets/post/1441532403000.json": "b38e72cb56b887c91c9454370bf52b1c",
"assets/assets/post/1442108223000.json": "e131f644b712b0de52c1d4459fec339f",
"assets/assets/post/1587111480000.json": "327cd693daae0b6a7e59afff32a96102",
"assets/assets/post/1460939305000.json": "c4e45839b4f41a7f726253e1f0e7f1b1",
"assets/assets/post/1474966711000.json": "887917d8cb7462a57ddbaf4d5b9f122a",
"assets/assets/post/1463439136000.json": "36b5c68df26bd5968a93e37a1016b527",
"assets/assets/post/1416343308000.json": "7a6b79d8ff577939891a5d5919f76a96",
"assets/assets/post/1441545072000.json": "26121879f754793f9dedd32602b7c81a",
"assets/assets/post/1473840792000.json": "ffa1db3ef75f52704cc44e061ed4b28a",
"assets/assets/post/1434935730000.json": "c736d837b1a08a0249d999de6a191e46",
"assets/assets/post/1462923372000.json": "10034548370206b7efa5681f54731027",
"assets/assets/post/1474451773000.json": "53110e04d5f67e7c78f997cb25617f96",
"assets/assets/post/1511169905000.json": "6b745eb62bd7b0bb0ff89da2e4ebe3e0",
"assets/assets/post/1457322825000.json": "82acb79141f6aae3a0d76fa50f648d49",
"assets/assets/post/1420437455000.json": "7d534dbe98bffe7fd18d2b10c76a7751",
"assets/assets/post/1472717515000.json": "16fab5068bf388e5b87551903a2c0af2",
"assets/assets/post/1510825085000.json": "a90b09a1a9845157d3fbee60d31cd17f",
"assets/assets/post/1432508835000.json": "617af33f64d89c0c6a98fc43ff6e6f80",
"assets/assets/post/1660311892000.json": "415699848d5987d8349db2e21d9ecf76",
"assets/assets/post/1462241414000.json": "c582ee7712ebcd71020ff62c8fd7e839",
"assets/assets/post/1441491175000.json": "257e273ed483568e3da7430b46834e52",
"assets/assets/post/1587361762000.json": "67378b1d24bf5da9d8dd913be7bee8be",
"assets/assets/post/1444927898000.json": "d7df02b7a8d9b98dc781888a7cc71553",
"assets/assets/post/1510224111000.json": "ec739c525717ff9bd74de48400f8bf7e",
"assets/assets/post/1457895358000.json": "afa3f6e6f4b38342571fd414c45e11b6",
"assets/assets/post/1473323318000.json": "29585619682fc0d81e67942699928d1f",
"assets/assets/post/1661152070000.json": "905059211caa984c3d870cc0d7eb4102",
"assets/assets/post/1435601853000.json": "ff9fcb2bf2fd6a81ecdbdd868b833276",
"assets/assets/post/1442731873000.json": "985c1e66f081d5cc4f8fadd3b03a2e43",
"assets/assets/post/1474450468000.json": "bcbcdf3c8efc3fb2851641333de99efa",
"assets/assets/post/1441657753000.json": "30f4138f095bdea3818862fdd158f9cf",
"assets/assets/post/1461009001000.json": "6f66186f7970c1b309bcef9d31ec7dde",
"assets/assets/post/1654653804000.json": "b8a44e042ac68d8536f7d1d72fa1355b",
"assets/assets/post/1462937553000.json": "b61eae192d432910acfeb914c187db34",
"assets/assets/post/1433201947000.json": "2e0966422824dfe14ea4ea43a6679224",
"assets/assets/post/1589770603000.json": "9645bc6cd6f44f55b34ec04c52b70402",
"assets/assets/post/1486375472000.json": "a064d5e6c099aeb76e7130dfb100453e",
"assets/assets/post/1479871897000.json": "ec220be580de905c9ca02abd0e5a7dc8",
"assets/assets/post/1457393103000.json": "bf63466dfcb1310a4c5f56791edccf86",
"assets/assets/post/1511161335000.json": "d887ca930fce12b337f413164ac9e026",
"assets/assets/post/1476007017000.json": "9e9f6e438ca99f00ee8a3f0c1104832a",
"assets/assets/post/1493277598000.json": "034af402437c4a31affdd046a76fa9c5",
"assets/assets/post/1442111349000.json": "71770a424c1c996de65d9c847ec2b988",
"assets/assets/pages/about.md": "339e807cb93877c44c7ead211ddc7f08",
"assets/assets/pages/test.md": "58b6bd0f43bc3e3f75f5e35add0da081"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
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
