baseDir = "../assets/Level/Tiles/"

# NOTE - DO NOT REMOVE OR REORDER FILE LISTS

decorations = [
	"crystalfloorspikes.png",
	"crystalrock.png",
	"largecrystal.png",
	"largecrystal2.png",
	"rockbg.png",
	"signpost.png",
	"smallcrystal.png",
	"smallcrystal2.png",
	"rockpebble.png",
	"smallrock.png",
]
decorationsIceFire = [ # prefixed by ice or fire in assets
	"bg.png",
	"boulder.png",
	"fence.png",
	"fenceend.png",
	"floorspikes.png",
	"tree.png",
	"pebble.png",
	"shrub.png",
]

hazards = [
	"geyser.png",
	"spikes.png",
]
hazardsIceFire = [
	"spikes.png",
]


f = open("spright.conf", "w")

f.write("""padding 0
colorkey
pack rows
divisible-bounds 16
align 0 bottom

""")

def thing(name, path, fileList, t=""):
	d = baseDir + path
	f.write("sheet \"{}{}\"\n".format(t, name))
	for i in fileList:
		f.write("\tinput {}{}{}\n".format(d, t, i))
	f.write("\toutput {}{}{}.png\n\n".format(baseDir, t, name))

thing("decorations", "Decorations/other/", decorations)
thing("decorations", "Decorations/icefire/", decorationsIceFire, "ice")
thing("decorations", "Decorations/icefire/", decorationsIceFire, "fire")

thing("hazards", "Hazards/other/", hazards)
thing("hazards", "Hazards/icefire/", hazardsIceFire, "ice")
thing("hazards", "Hazards/icefire/", hazardsIceFire, "fire")

f.close()
