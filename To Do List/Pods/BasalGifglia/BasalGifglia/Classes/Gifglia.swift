//
//  Gifglia.swift
//  Pods
//
//  Created by Akash Desai on 10/10/16.
//
//

import Foundation

internal enum Gifglia: Int {
    case carltonDance = 0,
    communityHighFive,      // 1
    dancingBabies,
    picardSlowClap,
    pugBellyRub,
    shaqAndKittyShimmy,     // 5
    woah,
    backflipBunny,
    balooBop,
    cheerfulCub,
    ecstaticAustrian,       // 10
    fistPumpingPitt,
    frolickingJerry,
    goodMoodMinions,
    jazzedJonah,
    krazyKermit,            // 15
    patrickThePatron,
    retroRocking,
    upbeatBarney,
    winkingRobin,
    yayBowie                // 20
    
    
    internal var filename: String {
        switch self {
        case .carltonDance: return "carlton dance"
        case .communityHighFive: return "community high five"
        case .dancingBabies: return "dancing babies"
        case .picardSlowClap: return "picard slow clap"
        case .pugBellyRub: return "pug belly rub"
        case .shaqAndKittyShimmy: return "shaq and kitty shimmy"
        case .woah: return "woah"
        case .backflipBunny: return "backflip bunny"
        case .balooBop: return "baloo bop"
        case .cheerfulCub: return "cheerful cub"
        case .ecstaticAustrian: return "ecstatic austrian"
        case .fistPumpingPitt: return "fist pumping pitt"
        case .frolickingJerry: return "frolicking jerry"
        case .goodMoodMinions: return "good mood minions"
        case .jazzedJonah: return "jazzed jonah"
        case .krazyKermit: return "krazy kermit"
        case .patrickThePatron: return "patrick the patron"
        case .retroRocking: return "retro rocking"
        case .upbeatBarney: return "upbeat barney"
        case .winkingRobin: return "winking robin"
        case .yayBowie: return "yay bowie"
        }
    }
        
    private static let defaults = UserDefaults.standard
    private static let distributionKey = "GifgliaDistribution"
    private static var distribution: [Int] {
        get {
            if let savedDistributionData = defaults.object(forKey: distributionKey) as? NSData,
                let savedDistribution = NSKeyedUnarchiver.unarchiveObject(with: savedDistributionData as Data) as? [Int] {
                return savedDistribution
            } else {
                var initialDistribution:[Int] = []
                for i in 0...20 {
                    initialDistribution.append(i)
                    initialDistribution.append(i)
                    initialDistribution.append(i)
                    initialDistribution.append(i)
                }
                defaults.set(NSKeyedArchiver.archivedData(withRootObject: initialDistribution), forKey: distributionKey)
                return initialDistribution
            }
        }
        set(updatedDistribution) {
            if updatedDistribution.count < 1 {
                defaults.removeObject(forKey: distributionKey)
            } else {
                defaults.set(NSKeyedArchiver.archivedData(withRootObject: updatedDistribution), forKey: distributionKey)
            }
        }
    }
    
    internal static func getNextGif() -> Gifglia {
        var distribution = Gifglia.distribution
        let nextGifIndex = Int(arc4random_uniform(UInt32(distribution.count)))
        let nextGif = distribution.remove(at: nextGifIndex)
        Gifglia.distribution = distribution
        
        return Gifglia(rawValue: nextGif)!
    }
}
