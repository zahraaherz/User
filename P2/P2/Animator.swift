//
//  Animator.swift
//  P2
//
//  Created by Zahraa Herz on 06/06/2022.
//

import UIKit

final class Animator {
    
    private var hasAnimatedAllCells = false
    private let animation: Animation

    init(animation: @escaping Animation) {
        self.animation = animation
    }

    func animate(cell: UICollectionViewCell, at indexPath: IndexPath, in collectionView: UICollectionView) {
        guard !hasAnimatedAllCells else {
            return
        }

        animation(cell, indexPath, collectionView)
        hasAnimatedAllCells = collectionView.isLastVisibleCell(at: indexPath)
    }
}

