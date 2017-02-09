//
//  FirebaseModel.swift
//  Optifire
//
//  Created by Иван Труфанов on 09.02.17.
//  Copyright © 2017 Werbary. All rights reserved.
//

import Foundation

public enum OptifireModelStatus {
    case local
    case synced
    case changed
}

open class OptifireModel: NSObject {
    var uid: String?
    var lastUpdated: TimeInterval?
    var createdAt: TimeInterval?
    
    //MARK: INIT
    required public override init() {
        self._firebaseContent = [:]
    }
    required public init (uid: String) {
        self.uid = uid
    }
    required public init (firebaseContent: [String: AnyObject]) {
        self._firebaseContent = firebaseContent
    }
    
    //MARK: STATIC
    open class func collection() -> String! {
        return "unknown"
    }
    
    public static func load(id: String!, success: OptifireSuccess?, failure: OptifireFailure?) {
        let model = self.init(uid: id)
        model.load(success: success, failure: failure)
    }

    //MARK: GETTERS
    public func collection() -> String! {
        return type(of: self).collection()
    }
    public func status() -> OptifireModelStatus {
        if let fbContent = self._firebaseContent {
            let valuesInModel = self.allValues()
            
            if NSDictionary(dictionary: valuesInModel).isEqual(to: fbContent) {
                return .synced
            }
            
            return .changed
        } else {
            return .local
        }
    }
    public func dateLastUpdated() -> Date? {
        if self.lastUpdated != nil {
            return Date(timeIntervalSince1970: self.lastUpdated!)
        } else {
            return nil
        }
    }
    public func dateCreatedAt() -> Date? {
        if self.createdAt != nil {
            return Date(timeIntervalSince1970: self.createdAt!)
        } else {
            return nil
        }
    }
    
    //MARK: ACTIONS
    public func save(success: OptifireSuccess?, failure: OptifireFailure?) {
        let collection = Optifire.shared.ref.child(self.collection())
        
        let key: String!
        if let uid = self.uid {
            key = uid
        } else {
            key = collection.childByAutoId().key
            self.uid = key
        }
        
        self.lastUpdated = Date().timeIntervalSince1970
        
        if self.createdAt == nil {
            self.createdAt = self.lastUpdated
        }
        
        let newData = self.allValues()
        
        let childUpdates = ["/\(self.collection()!)/\(key!)": newData]

        Optifire.shared.ref.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
            if error == nil {
                if let success = success {
                    success(self)
                }
            } else {
                if let failure = failure {
                    failure(self,error)
                }
            }
        })
    }
    public func load(success: OptifireSuccess?, failure: OptifireFailure?) {
        Optifire.shared.ref.child(collection()).child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let firebaseContent = snapshot.value as? [String : AnyObject] ?? [:]
            self._firebaseContent = firebaseContent
    
            self.fillValues(from: firebaseContent)
            
            if let success = success {
                success(self)
            }
        }) { (error) in
            if let failure = failure {
                failure(self, error)
            }
        }
    }
    
    //MARK: PRIVATE
    private var _firebaseContent: [String: AnyObject]?
    func allValues() -> [String: AnyObject] {
        let type: Mirror = Mirror(reflecting:self)

        var resultDictionary = self.getValuesOfMirror(type: type)
        
        var currentMirror = type
        
        while currentMirror.superclassMirror != nil {
            currentMirror = currentMirror.superclassMirror!
            
            var valuesSuper = self.getValuesOfMirror(type: currentMirror)
            
            for (key, value) in valuesSuper {
                resultDictionary[key] = value
            }
        }
        
        return resultDictionary
    }
    func getValuesOfMirror(type: Mirror!) -> [String: AnyObject] {
        var resultDictionary = [String: AnyObject]()
        
        for child in type.children {
            if !child.label!.hasPrefix("_")
            {
                resultDictionary[child.label!] = child.value as AnyObject
            }
        }
        
        return resultDictionary
    }
    func fillValues(from dictionary: [String: AnyObject]) {
        for (key, value) in dictionary {
            if (self.responds(to: NSSelectorFromString(key))) {
                self.setValue(value, forKey: key)
            }
        }
    }
}
