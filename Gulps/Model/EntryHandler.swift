import Foundation
import Realm

public class EntryHandler: NSObject {
    public func currentEntry() -> Entry {
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.natashaTheRobot.BigGulp")!
        let realmPath = directory.path!.stringByAppendingPathComponent("db.realm")
        RLMRealm.setDefaultRealmPath(realmPath)
        
        if let entry = Entry.entryForToday() {
            return entry
        } else {
            let newEntry = Entry()
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            newEntry.percentage = 0
            newEntry.quantity = 0
            realm.addObject(newEntry)
            realm.commitWriteTransaction()
            return newEntry
        }
    }

    public func addGulp(quantity: Double) {
        let entry = currentEntry()
        entry.addGulp(quantity, goal: NSUserDefaults.groupUserDefaults().doubleForKey(Settings.Gulp.Goal.key()), realm: RLMRealm.defaultRealm())
    }

    public func removeLastGulp() {
        let realm = RLMRealm.defaultRealm()
        let entry = currentEntry()
        if let gulp = entry.gulps.lastObject() as? Gulp {
            entry.removeLastGulp(realm)
            realm.beginWriteTransaction()
            realm.deleteObject(gulp)
            realm.commitWriteTransaction()
        }
    }
}
