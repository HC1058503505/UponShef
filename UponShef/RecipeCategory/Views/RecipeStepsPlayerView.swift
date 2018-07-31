//
//  RecipeStepsPlayerView.swift
//  UponShef
//
//  Created by cgtn on 2018/7/30.
//  Copyright © 2018年 houcong. All rights reserved.
//

import UIKit
import AVKit

class RecipeStepsPlayerView: UIView {

    fileprivate var avPlayer: AVPlayer?
    fileprivate let avplayerLayer = AVPlayerLayer(player: nil)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        backgroundColor = UIColor.black
        layer.addSublayer(avplayerLayer)
        
    }
    
    func sourcePlayer(url: URL) {
        let avAsset = AVAsset(url: url)
        let avplayerItem = AVPlayerItem(asset: avAsset)
        let player = AVPlayer(playerItem: avplayerItem)
        avplayerLayer.player = player
        avPlayer = player
        avplayerLayer.contentsGravity = kCAGravityCenter
    }
    
    func play() {
        
        avPlayer?.play()
    }
    
    func pause() {
        avPlayer?.pause()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avplayerLayer.frame = bounds
    }
}
