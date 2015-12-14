//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
//:
//: ---
//:
//: ## AKDecimator
//: ### Add description
import XCPlayground
import AudioKit

//: Change the source to "mic" to process your voice
let source = "player"

let audiokit = AKManager.sharedInstance
let mic = AKMicrophone()
let bundle = NSBundle.mainBundle()
let file = bundle.pathForResource("mixloop", ofType: "wav")
let player = AKAudioPlayer(file!)
player.looping = true
let playerWindow: AKAudioPlayerWindow
let decimator: AKDecimator

switch source {
case "mic":
    decimator = AKDecimator(mic)
default:
    playerWindow = AKAudioPlayerWindow(player)
    let playerWithVolumeAndPanControl = AKMixer(player)
    decimator = AKDecimator(playerWithVolumeAndPanControl)
}

//: Set the parameters of the decimator here
decimator.decimation =  50 // Percent
decimator.rounding = 50 // Percent
decimator.mix = 50 // Percent

var decimatorWindow = AKDecimatorWindow(decimator)

audiokit.audioOutput = decimator
audiokit.start()

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
