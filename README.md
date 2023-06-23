# The Turks
2d Unity project \
~~Tile sets created with Photoshop~~ \
~~Tile maps and created with [Tiled](https://www.mapeditor.org/)~~

# Developer Notes

## Animating movement in Unity

### `23th June 2023`
Exported Shotgun's movement animation as frames and followed a Unity tutorial to implement [basic top-down movement](https://www.youtube.com/watch?v=whzomFgjT50).

Steps to export a sequence of frames from Photoshop.
1. Set each frame to 1 second in duration
2. File > Export > Render Video...
3. Under main settings, set type to `Photoshop Image Sequence` and framerate to `1`fps
4. Under render options set the `Alpha Channel` to `Straight - Unmatted`
5. Click `Render` to export a sequence of images on the format image0, image1...

## Ripping horizonal sprites from video

### `14th June 2023`
Strangely there are only 7 frames moving right (compared to 8 frames moving left), it also fits nicely within a 72x72px canvas. Results are fair. \
\
![shotgun animation (right)](/assets/sprites/shotgun/right.gif)

### `13th June 2023`
Attempt to rip sprites from an original video. Each horizontal animation has 8 frames and fits nicely within a 72x72px canvas. Results are fair. \
\
Steps to reproduce:
1. Video (512x386px, 30fps) downloaded from Niconico using the [nico downloader chrome plugin](https://chrome.google.com/webstore/detail/nico-downloader/dncjcadpoakefjpnabimpalenliehbig)
2. Use the _take snapshop_ feature in VLC media player along with the increment frame shortcut `e` to capture animation frames
3. Open all frames in Photoshop as different layers
4. Create a guide between the hips and align all images to the guide
5. Crop the image at 72x72px
6. Use the polygonal lasso tool to lift the sprite (and shadow) from the background
7. Create a second guide at the feet and align all images to the guide
8. Export a gif
\
![shotgun animation (left)](/assets/sprites/shotgun/left.gif)

## Ripping vertical sprites from video
### `12th June 2023`
Attempt to rip sprites from an original video. Each vertical animation has 6 frames and fits nicely within a 96x48px canvas. Results are fair. \
\
Steps to reproduce:
1. Video (512x386px, 30fps) downloaded from Niconico using the [nico downloader chrome plugin](https://chrome.google.com/webstore/detail/nico-downloader/dncjcadpoakefjpnabimpalenliehbig)
2. Use the _take snapshop_ feature in VLC media player along with the increment frame shortcut `e` to capture animation frames
3. Open all frames in Photoshop as different layers
4. Create a guide where both feet touch the ground and align all images to the guide (the guide is halfway between both feet)
5. Crop the image at 96x48px
6. Use the polygonal lasso tool to lift the sprite (and shadow) from the background
7. Export a gif
\
![shotgun animation (up)](/assets/sprites/shotgun/up.gif)
![shotgun animation (down)](/assets/sprites/shotgun/down.gif)

## Removing sprites from screenshots
### `27th May 2023`
Used an online AI-based tool ([cleanup.pictures](https://cleanup.pictures/)) to remove sprites from screenshots with the intention of using the clean background images. Results are excellent.
\
![train](/screenshots/train.jpg)
![train-cleanup](/screenshots/train_cleanup.jpg)

## Cleaned up Cissnei sprites
### `9th December 2020`
Tidied up some ripped Cissnei sprites using a level adjustment filter in Photoshop to remove the blue light and then running it through Waifu2x to enhance the images. Results are poor.
\
\
Sprites shared by `obesebear` on the [qhimm.com forums](https://forums.qhimm.com/index.php?topic=19983.0)
\
\
![upscale-sample](/assets/sprites/cissnei-example.png)

## Results of google translate
### `6th December 2020`
![menu](/assets/ui/menu.png)
![menu-translated](/assets/ui/menu-translated.png)

## Upscaled images with the Waifu2x model
### `5th December 2020`
Experimenting with ESRGAN (Enhanced Super-Resolution Generative Adversarial Networks) to enhance the screenshots using a ML neural network.

- ~~[ESRGAN](https://github.com/JoeyBallentine/ESRGAN) sample project~~
- ~~[Cupscale](https://github.com/n00mkrad/cupscale) ESRGAN UI wrapper~~
- [Waifu project](https://github.com/nagadomi/waifu2x) with model trained on Anime images
- [Waifu2x-caffe](https://github.com/lltcggie/waifu2x-caffe) a Waifu UI wrapper
- The ideal [settings](https://github.com/nagadomi/waifu2x/issues/201) to emulate the waifu [demo website](http://waifu2x.udp.jp/)


The below screenshots are the before and after an upscaling with the waifu2x model using the Windows desktop tool, (with the specific settings) mentioned above. I like the final result, it has a cel-shaded look to it.
\
![upscale-sample](/screenshots/upscale-sample.jpg)
\
![upscale-enhanced](/screenshots/upscale-enhanced.png)

## Weird tiles
### `13th November 2020`
All quality screenshots are at 240x240px. But when trying to recreate a scene the tiles appear to be 26x26px (which isn't the typical 2^n) and the overall map is either 260px (or more likely 256px) and then the scene is cropped 16px from the left and 18px from the top. 
\
I've double and triple checked the tiles as a game on a low powered machine should be running optimal tile sets, but the tiles are lining up. Strange???
\
The below screenshots were taken at 200% zoom in Photoshop
![no-grid screenshot](/screenshots/no-grid.png)
![grid screenshot](/screenshots/grid.png)
![animated grid screenshot](/screenshots/animated-grid.gif)
