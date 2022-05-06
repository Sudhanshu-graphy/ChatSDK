//
//  UICollectionViewLayout+Helper.swift
//  Graphy
//
//  Created by Raj Dhakate on 17/08/21.
//

import Foundation
import UIKit

extension UICollectionViewLayout {
    func createCommunityLayout() -> UICollectionViewLayout {
        // Create Size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(85))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Create Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(85))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [ item ])

        // Create Section
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createSchedulerLayout(addFooterSpace: Bool? = false) -> UICollectionViewLayout {
        // Create Size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(85))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Create Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(85))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [ item ])
        
        // Create Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)
        
        if addFooterSpace == true {
            // create 65 px footer size + 10px for padding
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(75))
            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
            section.boundarySupplementaryItems = [ footer ]
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createHamburgerCommunityLayout() -> UICollectionViewLayout {
        // Create Size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(72))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Create Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(72))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [ item ])

        // Create Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createHamburgerCoursesLayout() -> UICollectionViewLayout {
        // create header size
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(52))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = .init(top: 10, leading: 0, bottom: -10, trailing: 0) // -10 at bottom to compensate the bottom contentInset of section
        
        // create 1 px footer size
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(0.5))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        // Create Size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(52))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Create Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(52))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [ item ])
        
        // Create Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [ header, footer ]
        section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createHamburgerFooterLayout() -> UICollectionViewLayout {
        // Create Size
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(52))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Create Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(52))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [ item ])

        // Create Section
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createProfileSocialLinksLayout() -> UICollectionViewLayout {
        // Create Size
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(40), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Create Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [ item ])
        group.interItemSpacing = .fixed(16)

        // Create Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createShareControllerLayout() -> UICollectionViewLayout {
        // Create Size
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(90), heightDimension: .absolute(90))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Create Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [ item ])

        // Create Section
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
