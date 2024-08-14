## BeatSaber Level Info

对于每个关卡，我们主要解析两个 json 文件：

- info.dat
- difficity.dat

先来看看 info.dat 的格式：

```json
{
  "_version": "2.0.0",
  "_songName": "foo.mp3",
  "_songSubName": "",
  "_songAuthorName": "bar",
  "_levelAuthorName": "Beat Sage",
  "_beatsPerMinute": 120.0, // 歌曲的每分钟节拍数（BPM），决定了关卡中所有节拍的时间间隔。
  "_songTimeOffset": 0, // 歌曲播放的时间偏移量（以秒为单位），用于调整音乐的起始时间。
  "_shuffle": 0.0, // 用于控制音符的随机化，这个字段在某些自定义地图中用于改变音符的顺序。0 表示没有随机化。
  "_shufflePeriod": 0.5, // 控制音符随机化的时间段，影响音符被打乱的程度。
  "_previewStartTime": 1.0, // 音乐预览的起始时间（以秒为单位）。这是玩家在歌曲选择时听到的预览音乐的起始位置。
  "_previewDuration": 30, // 预览音乐的持续时间（以秒为单位）。
  "_songFilename": "song.ogg",
  "_coverImageFilename": "cover.jpg",
  "_environmentName": "DefaultEnvironment",
  "_allDirectionsEnvironmentName": "GlassDesertEnvironment",
  "_difficultyBeatmapSets": [
    {
      "_beatmapCharacteristicName": "NoArrows",
      "_difficultyBeatmaps": [
        {
          "_difficulty": "Hard",
          "_difficultyRank": 5,
          "_beatmapFilename": "NoArrowsHard.dat",
          "_noteJumpMovementSpeed": 10,
          "_noteJumpStartBeatOffset": 0.0
        }
      ]
    }
  ],
  "_customData": {
    "_editors": {
      "_lastEditedBy": "beatsage",
      "beatsage": {
        "version": "2.0.0.flow",
        "id": "cb3836570e8e40a888a0fe3a61e8cb26",
        "events": [
          "DotBlocks"
        ]
      }
    }
  }
}
```

difficity.dat 的格式为：

```js
{
  "_version": "2.0.0",
  "_events": [],
  "_notes": [
    {
      "_time": 3.4583730680651827,
      "_lineIndex": 2, // 水平方向从左到右的位置，取值范围 0-3
      "_lineLayer": 0, // 垂直方向从上到下的位置，取值范围 0-2
      "_type": 1, // 方块类型，0 为左手方块，1 为右手方块，3 为炸弹
      "_cutDirection": 8 // 方块需要切割的方向（0-8 代表不同的方向，8 通常表示不限定方向的切割）
    },
   ]
}
```

在 Beat Saber 中，关卡的节拍时间（`_time`）通常是以音乐的节拍（BPM, Beats Per Minute）为单位进行计算的。理解这种计算方式对于关卡设计非常重要，因为它决定了游戏中所有方块、障碍物和事件的出现时间与音乐的同步。

### 1. **BPM（Beats Per Minute）**

- **BPM** 是音乐的速度，表示每分钟的节拍数。一个典型的4/4拍歌曲的 BPM 通常在120-140之间，当然也有更快或更慢的。
- 例如：如果一首歌的 BPM 是 120，那么每分钟有 120 个节拍，也就是每秒有 2 个节拍。

### 2. **_time 的计算**

在 Beat Saber 中，`_time` 表示一个方块、障碍物或事件出现的时间，以**节拍数**为单位，而不是以秒为单位。

- **节拍时间的计算**：`_time` 表示该事件在整个歌曲中的第几个节拍时刻发生。

- **1个节拍的时间**：在歌曲的时间轴上，一个节拍的时间等于 60 秒除以歌曲的 BPM。

  例如：

  - 对于 BPM 为 120 的歌曲，1个节拍时间 = 60秒 / 120BPM = 0.5秒。