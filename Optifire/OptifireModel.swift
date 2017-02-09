//
//  FirebaseModel.swift
//  Optifire
//
//  Created by Иван Труфанов on 09.02.17.
//  Copyright © 2017 Werbary. All rights reserved.
//

import Foundation

enum OptifireModelStatus {
    case local
    case synced
    case changed
}

class OptifireModel {
    var uid: String?
    var lastUpdated: Date?
    var createdAt: Date?
    
    //MARK: INIT
    required init() {
        self._firebaseContent = [:]
    }
    required init (with id: String) {
        self.uid = id
    }
    required init(with firebaseContent: [String: AnyObject]) {
        self._firebaseContent = firebaseContent
    }
    
    //MARK: STATIC
    static func collection() -> String! {
        return "unknown"
    }
    
    static func load(id: String!, success: OptifireSuccess?, failure: OptifireFailure?) {
        let model = self.init(with: id)
        model.load(success: success, failure: failure)
    }

    //MARK: GETTERS
    func collection() -> String! {
        return type(of: self).collection()
    }
    
    func status() -> OptifireModelStatus {
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
    
    //MARK: ACTIONS
    func save(success: OptifireSuccess?, failure: OptifireFailure?) {
        let collection = Optifire.shared.ref.child(self.collection())
        
        let key: String!
        if let uid = self.uid {
            key = uid
        } else {
            key = collection.childByAutoId().key
            self.uid = key
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
    
    func load(success: OptifireSuccess?, failure: OptifireFailure?) {
        Optifire.shared.ref.child(collection()).child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let firebaseContent = snapshot.value as? [String : AnyObject] ?? [:]
            self._firebaseContent = firebaseContent
            
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
            
            for key in valuesSuper.keys {
                resultDictionary[key] = valuesSuper[key]
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
}
