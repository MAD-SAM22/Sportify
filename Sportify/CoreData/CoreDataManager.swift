//
//  CoreDataManager.swift
//  Sportify
//
//  Created by Osama Hosam on 22/05/2026.
//
import UIKit
import CoreData

class CoreDataManager {
    
    // 1. Singleton instance so we use the same manager everywhere
    static let shared = CoreDataManager()
    let context: NSManagedObjectContext

    private init() {
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    }
    
    
    // Testing init — accepts injected context
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    // MARK: - CRUD Operations
    
    func saveLeagueToFavorites(league: League, sportName: String) {
        // Prevent duplicates
        guard let key = league.leagueKey, !isFavorite(leagueKey: key) else { return }
        
        let entity = FavoriteLeagueEntity(context: context)
        entity.leagueKey = Int64(key)
        entity.leagueName = league.leagueName
        entity.leagueLogo = league.leagueLogo
        entity.sportName = sportName
        
        do {
            try context.save()
            print("League saved to favorites successfully!")
        } catch {
            print("Error saving league: \(error.localizedDescription)")
        }
    }
    
    func fetchFavoriteLeagues() -> [League] {
        let request: NSFetchRequest<FavoriteLeagueEntity> = FavoriteLeagueEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            // Map the CoreData entities back to our standard League struct
            return entities.map { entity in
                League(
                    leagueKey: Int(entity.leagueKey),
                    leagueName: entity.leagueName,
                    leagueLogo: entity.leagueLogo,
                    sportName: entity.sportName
                )
            }
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteLeagueFromFavorites(leagueKey: Int) {
        let request: NSFetchRequest<FavoriteLeagueEntity> = FavoriteLeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %d", leagueKey)
        
        do {
            let entities = try context.fetch(request)
            if let entityToDelete = entities.first {
                context.delete(entityToDelete)
                try context.save()
                print("League removed from favorites!")
            }
        } catch {
            print("Error deleting league: \(error.localizedDescription)")
        }
    }
    
    // 3. Helper to check if a league is already favorited (Needed for the details screen later)
    func isFavorite(leagueKey: Int) -> Bool {
        let request: NSFetchRequest<FavoriteLeagueEntity> = FavoriteLeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %d", leagueKey)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
}
