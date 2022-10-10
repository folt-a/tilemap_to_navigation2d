# Tilemap to Navigation2d

version：Godot 4.0 beta 2 Addon.

Create a Navigation2DRegion from the tiles painted on the TileMap node on the scene.

Godotのアドオンです。

シーン上のTileMapノードに塗ったタイルから、Navigation2DRegionを作成します。

---

## English

In the scene view, when the TileMap node is selected, the commands are added at the bottom of the inspector.

![image](https://user-images.githubusercontent.com/32963227/194799260-b26a23a0-8b1e-48dc-8363-f98f94273943.png)

---

## Setting 1

![image](https://user-images.githubusercontent.com/32963227/194799379-9d079dd5-5d3b-484e-8a40-11e48e779607.png)


---

## Setting 2

![image](https://user-images.githubusercontent.com/32963227/194799561-a3e78086-ca3a-48a5-b403-dabaf37c0627.png)

Select "hole" in the generated NavigationRegion2D navpoly's polygon.

---

## Setting 3

![image](https://user-images.githubusercontent.com/32963227/194800005-0cebab63-6ac2-4860-b2a4-cb433997b633.png)

If there is already a node named "NavigationRegion2D", choose whether to overwrite it or add a new node without deleting it.

If you do not overwrite it, it will be added with a node name like "@NavigationRegion2D@24847".

---

## Setting 4

![image](https://user-images.githubusercontent.com/32963227/194798705-b2630dd8-8db4-4a09-8622-0659bfa219a2.png)

Creates a margin from the wall. Specify the number of pixels.

This can be used when you want people to walk along the navigation, but do not want them to walk along the edge of the wall.

example 32 pixel tileset

gap 1 pixel

![image](https://user-images.githubusercontent.com/32963227/194798904-f90a5a72-64e7-4b40-acc3-db5baad25fa1.png)

gap 4 pixel

![image](https://user-images.githubusercontent.com/32963227/194798933-0e027abb-171f-4e3f-9d7a-0fb2d174abd4.png)

gap 15 pixel

![image](https://user-images.githubusercontent.com/32963227/194798989-e3c3410d-dec6-4a4d-af0a-5c54f8e0b5c9.png)

---

## 日本語

シーンで、TileMapノードを選択したときのインスペクタの一番下にこのような項目が追加されます。

![image](https://user-images.githubusercontent.com/32963227/194798308-e0c97717-9a67-4941-9724-bbf13a6cf638.png)

---

## 1つ目の設定

![image](https://user-images.githubusercontent.com/32963227/194798380-fabf501c-1c75-4c04-b4f8-007bee78c53a.png)

選択しているTileMapノードのみを対象とするか、現在のシーンに存在するすべてのTileMapノードを対象とするか選択します。

---

## 2つ目の設定

![image](https://user-images.githubusercontent.com/32963227/194798573-1e4a1710-294d-42a5-a3fc-b304754d95ca.png)

生成されるNavigationRegion2Dのnavpolyのポリゴンの「穴」とするタイルを選択します。

---

## 3つ目の設定

![image](https://user-images.githubusercontent.com/32963227/194798601-a5a91dd0-64da-4700-85be-0f4ded563e5c.png)

すでに「NavigationRegion2D」という名前のノードがある場合に、上書きするか消さずに新規追加するか選択します。

消さない場合は「@NavigationRegion2D@24847」みたいな感じのノード名で追加されます。

---

## 4つ目の設定

![image](https://user-images.githubusercontent.com/32963227/194798705-b2630dd8-8db4-4a09-8622-0659bfa219a2.png)

壁から余白を作ります。ピクセル数を指定します。

ナビゲーションに沿って歩いてほしいが、壁きわきわに歩いてほしくないときに使えます。

32pixelタイルでの例

余白1pixel

![image](https://user-images.githubusercontent.com/32963227/194798904-f90a5a72-64e7-4b40-acc3-db5baad25fa1.png)

余白4pixel

![image](https://user-images.githubusercontent.com/32963227/194798933-0e027abb-171f-4e3f-9d7a-0fb2d174abd4.png)

余白15pixel

![image](https://user-images.githubusercontent.com/32963227/194798989-e3c3410d-dec6-4a4d-af0a-5c54f8e0b5c9.png)


---
GDExtensionのコードはこちら

(このアドオンにビルド済みのバイナリが含まれているので使う必要はありません)

https://github.com/folt-a/gdextension_clipper_singleton
