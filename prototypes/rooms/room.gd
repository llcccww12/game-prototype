[gd_scene load_steps=2 format=3 uid="uid://room_0"]

[ext_resource type="Script" path="res://rooms/room.gd" id="1_room"]

[sub_resource type="RectangleShape2D" id="RectangleShape2D_floor"]
size = Vector2(800, 600)

[node name="Room" type="Node2D"]
script = ExtResource("1_room")

[node name="Floor" type="ColorRect" parent="."]
offset_left = -400.0
offset_top = -300.0
offset_right = 400.0
offset_bottom = 300.0
color = Color(0.08, 0.08, 0.12, 1.0)

[node name="Walls" type="Node2D" parent="."]

[node name="WallTop" type="StaticBody2D" parent="Walls"]
position = Vector2(0, -300)

[node name="CollisionShape2D" type="CollisionShape2D" parent="Walls/WallTop"]
shape = SubResource("RectangleShape2D_floor")

[node name="WallBottom" type="StaticBody2D" parent="Walls"]
position = Vector2(0, 300)

[node name="CollisionShape2D" type="CollisionShape2D" parent="Walls/WallBottom"]
shape = SubResource("RectangleShape2D_floor")

[node name="WallLeft" type="StaticBody2D" parent="Walls"]
position = Vector2(-400, 0)

[node name="CollisionShape2D" type="CollisionShape2D" parent="Walls/WallLeft"]
shape = SubResource("RectangleShape2D_floor")

[node name="WallRight" type="StaticBody2D" parent="Walls"]
position = Vector2(400, 0)

[node name="CollisionShape2D" type="CollisionShape2D" parent="Walls/WallRight"]
shape = SubResource("RectangleShape2D_floor")
