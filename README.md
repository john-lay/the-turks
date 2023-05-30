# the-turks
2d Unity project \
Tile sets created with Photoshop \
Tile maps and created with [Tiled](https://www.mapeditor.org/)

# Developer Notes

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
