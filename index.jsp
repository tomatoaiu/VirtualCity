<%-- 
    Document   : index
    Created on : 2017/01/18, 12:21:18
    Author     : g031n112
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="UTF-8">
        <title>Hello, Three.js World!</title>
        <script src="js/three.min.js"></script>

    </head>
    <body>
        <div id="container">

            <script type = "text/javascript" src =" js/OrbitControls.js"></script>

            <script type = "text/javascript" src = "js/DDSLoader.js"></script>
            <script type = "text/javascript" src = "js/MTLLoader.js"></script>
            <script type = "text/javascript" src = "js/OBJLoader.js"></script>
            <script>
                var main = function () {

                    var camera, scene, renderer;
                    var scene = new THREE.Scene();
                    var width = window.innerWidth;
                    var height = window.innerHeight;
                    var fov = 60;
                    var aspect = width / height;
                    var near = 1;
                    var far = 1000;
                    var camera = new THREE.PerspectiveCamera(fov, aspect, near, far);
                    camera.position.set(80, 100, 150); // カメラの位置(x, y, z)

                    // レンダラー生成
                    var renderer = new THREE.WebGLRenderer();
                    renderer.setSize(width, height);
                    renderer.setClearColor(0xFFFFFF, 1.0);
                    document.body.appendChild(renderer.domElement);

                    var frame;

                    // マウスコントロール
                    var controls;
                    controls = new THREE.OrbitControls(camera);

                    // ライトの生成
                    var directionalLight = new THREE.DirectionalLight(0xffffff, 1.7);
                    directionalLight.position.set(0.577, 1, 0.577);
                    scene.add(directionalLight);
                    var directionalLight2 = new THREE.DirectionalLight(0xffffff, 1);
                    directionalLight2.position.set(-0.577, 0, -0.577);
                    scene.add(directionalLight2);
                    

                    //----------------------------空生成------------------------------------

                    scene.fog = new THREE.Fog(0xE0E0F0, 50, 500); // フォグ（霧みたいなの）の生成

                    var backgroundTexture = THREE.ImageUtils.loadTexture("images/background.jpg");

                    function background(x, y, z, d) {
                        var material = new THREE.MeshPhongMaterial({
                            map: backgroundTexture,
                            color: 0xffffff
                        });
                        var plane = new THREE.PlaneGeometry(1500, 1500, 1, 1);
                        var mesh = new THREE.Mesh(plane, material);
                        if (d === "grond") { // 地面
                            mesh.rotation.x = Math.PI / -2; // 地面を水平に
                        } else if (d === "right") {
                            mesh.rotation.y = Math.PI / -2;
                        } else if (d === "left") {
                            mesh.rotation.y = Math.PI / 2;
                        } else if (d === "ceiling") {
                            mesh.rotation.x = Math.PI / 2;
                        } else if (d === "front") {
                            mesh.rotation.x = 160.215;
                        }


                        mesh.position.set(x, y, z);
                        scene.add(mesh);
                    }
                    background(0, -100, 0, "grond");
                    background(400, 0, 0, "right");
                    background(-400, 0, 0, "left");
                    background(0, 0, -400, "back");
                    background(0, 400, 0, "ceiling");
                    background(0, 0, 400, "front");


                    //----------------------------空生成ここまで------------------------------------



                    //----------------------------人生成------------------------------------

                    var onProgress = function (xhr) {
                        if (xhr.lengthComputable) {
                            var percentComplete = xhr.loaded / xhr.total * 100;
                            console.log(Math.round(percentComplete, 2) + '% downloaded');
                        }
                    };
                    var onError = function (xhr) {};
                    THREE.Loader.Handlers.add(/\.dds$/i, new THREE.DDSLoader());

                    // 普通状態の人の生成(x座標, y座標, z座標, マテリアル, オブジェクト)
                    function humanSpawn(x, y, z, mtl, obj) {
                        var mtlLoader = new THREE.MTLLoader();
                        mtlLoader.setPath('./human/');
                        mtlLoader.load(mtl, function (materials) {

                            materials.preload();
                            var objLoader = new THREE.OBJLoader();
                            objLoader.setMaterials(materials);
                            objLoader.setPath('./human/');
                            objLoader.load(obj, function (object) {

                                //object.position.y = 0; // objectの座標
                                object.position.set(x, y, z); // objectの座標
                                scene.add(object);
                            }, onProgress, onError);
                        });
                    }

                    // 普通状態の人
                    humanSpawn(-35, 0, -45, "red.mtl", "normal.obj");
                    humanSpawn(5, 0, 5, "blue.mtl", "normal.obj");
                    humanSpawn(-15, 0, -15, "green.mtl", "normal.obj");
                    humanSpawn(25, 0, 35, "yellow.mtl", "normal.obj");
                    humanSpawn(-45, 0, 5, "purple.mtl", "normal.obj");
                    humanSpawn(35, 0, 5, "skyblue.mtl", "normal.obj");

                    // 風邪の人
                    humanSpawn(-35, 0, -25, "red.mtl", "cold.obj");
                    humanSpawn(5, 0, 15, "yellow.mtl", "cold.obj");
                    humanSpawn(-5, 0, -15, "green.mtl", "cold.obj");
                    humanSpawn(-25, 0, 25, "blue.mtl", "cold.obj");
                    humanSpawn(-40, 0, 25, "purple.mtl", "cold.obj");
                    humanSpawn(35, 0, -35, "skyblue.mtl", "cold.obj");

                    // 健康な人
                    humanSpawn(-5, 0, -35, "green.mtl", "nice.obj");
                    humanSpawn(10, 0, 5, "yellow.mtl", "nice.obj");
                    humanSpawn(20, 0, -15, "red.mtl", "nice.obj");
                    humanSpawn(25, 0, -45, "blue.mtl", "nice.obj");
                    humanSpawn(35, 0, 25, "purple.mtl", "nice.obj");
                    humanSpawn(-45, 0, -35, "skyblue.mtl", "nice.obj");

                    //----------------------------人生成ここまで------------------------------------



                    //----------------------------ビル関係生成------------------------------------
                    
                    var buildingTexture = THREE.ImageUtils.loadTexture("images/buiding.png");
                    
                    // 配列作成、ビルの立てる場所の座標を格納した2次元配列
                    function coodinateGenerate() {
                        var array = [];
                        var exp1 = -50;
                        var exp2 = -50;
                        for (var i = 0; i < 100; i++, exp2 += 10) {
                            if (i !== 0 && i % 10 === 0) {
                                exp1 += 10;
                                exp2 = -50;
                            }
                            array[i] = [exp1, exp2];
                        }

                        return array;
                    }
                    // 配列をランダムに、ビルの建てる場所を配列に
                    function shuffleAry(ary) {
                        var i = ary.length;
                        while (i) {
                            var j = Math.floor(Math.random() * i);
                            var t = ary[--i];
                            ary[i] = ary[j];
                            ary[j] = t;
                        }
                        return ary;
                    }
                    var BuildingCoodinate = shuffleAry(coodinateGenerate());
                    

                    var buildCount = 0; // 棟数
                    // ビルの生成
                    function build() {
                        var rand = Math.floor(Math.random() * 10) + 25; // ビルの高さ　1 ～ 10 + 最低値
                        var geometry = new THREE.BoxGeometry(5, rand, 5); // 形( 横, 高さ, 奥行)
                        var material = new THREE.MeshLambertMaterial({
                            map: buildingTexture,
                            color: 0xffffff
                        }); // 色
                        var mesh = new THREE.Mesh(geometry, material); // 組み合わせる
                        //set(ビルの立てる場所のx座標, y座標は0だとビルの中心が地面になる, ビルの立てる場所のz座標)
                        mesh.position.set(BuildingCoodinate[buildCount][0], rand / 2, BuildingCoodinate[buildCount][1]);
                        scene.add(mesh);
                        buildCount++;
                    }
                    
                    //----------------------------ビル生成ここまで------------------------------------



                    //----------------------------道路関係生成------------------------------------
                    
                    // 画像をロードしておく
                    var earthTexture = THREE.ImageUtils.loadTexture("images/ground.jpg");
                    var roadTexture = THREE.ImageUtils.loadTexture("images/road.jpg");
                    var xroadTexture = THREE.ImageUtils.loadTexture("images/intersection.jpg");

                    // 十字路の道路生成
                    function xroad(x, z) {
                        var material = new THREE.MeshPhongMaterial({
                            map: xroadTexture,
                            color: 0xffffff
                        });
                        var plane = new THREE.PlaneGeometry(5, 5, 1, 10); // ( 大きさ, 大きさ, 分割, 分割)
                        var mesh = new THREE.Mesh(plane, material);
                        mesh.rotation.x = Math.PI / -2; // 地面を水平に
                        mesh.position.set(x, 0.1, z); //-35,-15,5,25
                        scene.add(mesh);
                    }

                    // 縦向きの道路生成(x座標, z座標, 道路画像の向き)
                    function road(x, z, direction) {
                        var material = new THREE.MeshPhongMaterial({
                            map: roadTexture,
                            color: 0xffffff
                        });
                        var plane = new THREE.PlaneGeometry(5, 5, 1, 10);
                        var mesh = new THREE.Mesh(plane, material);
                        mesh.rotation.x = Math.PI / -2; // 地面を水平に
                        if (direction === "tate") {
                            mesh.rotation.z = Math.PI / -2;
                        }
                        mesh.position.set(x, 0.1, z);
                        scene.add(mesh);
                    }

                    // 地面の生成
                    var material = new THREE.MeshPhongMaterial({
                        map: earthTexture,
                        color: 0xffffff
                    });
                    var plane = new THREE.PlaneGeometry(110, 110, 1, 1);
                    var mesh = new THREE.Mesh(plane, material);
                    mesh.rotation.x = Math.PI / -2; // 地面を水平に
                    mesh.position.set(-5, 0, -5);
                    scene.add(mesh);
                    frame = 0;

                    // 十字路の配置
                    for (i = -35; i <= 25; i += 20) {
                        for (j = -35; j <= 25; j += 20) {
                            xroad(i, j);
                        }
                    }

                    // 道路の配置
                    for (i = -55; i <= 45; i += 5) { // 列
                        for (j = -55; j <= 45; j += 5) { // 行
                            // 縦向きの道路生成判定
                            if (i === -35 || i === -15 || i === 5 || i === 25) {
                                if (j === -35 || j === -15 || j === 5 || j === 25) {
                                    continue; // 十字路なら配置しない
                                } else { // 列が十字路で、行が十字路でない場合
                                    road(i, j, "yoko"); // 縦向きの道路を生成
                                }
                            }

                            // 横向きの道路生成判定
                            if (j === -35 || j === -15 || j === 5 || j === 25) {
                                if (i === -35 || i === -15 || i === 5 || i === 25) {
                                    continue; // 十字路なら配置しない
                                } else { // 列が十字路でなく、行が十字路な場合
                                    road(i, j, "tate"); // 横向きの道路を生成
                                }
                            }
                        }
                    }

                    //----------------------------ここまで道路関係生成------------------------------------

                    function tick() { // sceneに追加したものを描画

                        requestAnimationFrame(tick);
                        // フレーム数をインクリメント
                        frame++;
                        controls.update(); // マウスに対応

                        // 描画
                        renderer.render(scene, camera);
                        // フレーム数が2,3,5,7で割り切れなければ描画しない
                        if (frame % 2 === 0 && frame % 3 === 0) {
                            if (frame % 5 === 0 && frame % 7 === 0) {
                                if (buildCount < 100) { // 100棟まで立てる
                                    build();
                                }
                                return;
                            }
                        }
                    }

                    tick();
                };
                window.addEventListener('DOMContentLoaded', main, false);
            </script>
        </div><!-- container -->
    </body>
</html>