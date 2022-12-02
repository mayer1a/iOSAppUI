//
//  VideoPlayerView.swift
//  VKApp
//
//  Created by Artem Mayer on 24.11.2022.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayer.self
    }

    var playerLayer: AVPlayerLayer? {
        return layer as? AVPlayerLayer
    }

    var player: AVPlayer? {
        get {
            return playerLayer?.player
        }

        set {
            playerLayer?.player = newValue
        }
    }

    
}
