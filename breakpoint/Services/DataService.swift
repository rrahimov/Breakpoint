//
//  DataService.swift
//  breakpoint
//
//  Created by Ruhullah Rahimov on 23.04.21.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
// This is instantiated outside of our class so that it's accessible to us in the class, because this class by itself doesn't have any initialiser, so we're initializing it outside of the class on purpose.

class DataService {
    static let instance = DataService()
// We're going to use data hiding as well. So that basically we can only set these values from inside the data service so that nobody else can access them no other class or no other method can access these except for the data service itself. It's a good way to be a safe coder:
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users") //creating folder to hold all the users
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
// Create public variables in order to set the value and actually be able to use the information (four public variables that are accessing the private ones):
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
// Now  if we ever need to set a value or access a value we can access ref groups. It's going to give us the value of these private variables so we can access the information of these by pulling from a private variable that way these themselves if they're modified it's going to only return the value that we've set.
    
// Create a function that's going to allow us to push a user into the user's feed and basically it's going to add a user into the Users folder:
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    //using Firebase closures, to get values out we need to use a completion handler
    func getUserName(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { userSnapshot in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["contents": message, "senderId": uid])
            sendComplete(true)
// This will create a messages folder inside any group, will assign each message a random ID and then inside that will have content message and the senderID from the UID.
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
    }
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { feedMessageSnapshot in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messageArray.append(message)
            }
            handler(messageArray)
        }
    }
    
    func getAllMessagesFor(desiredGroup: Group, handler: @escaping (_ messages: [Message]) -> ()  ) {
        var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("messages").observeSingleEvent(of: .value) { groupMessageSnapshot in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for groupMessage in groupMessageSnapshot {
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let groupMessage = Message(content: content, senderId: senderId)
                groupMessageArray.append(groupMessage)
            }
            handler(groupMessageArray)
        }
    }
    
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observe(.value) { userSnapshot in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                } //why no "else" here?
            }
            handler(emailArray)
        }
    }
    
    func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { userSnapshot in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot  {
                let email = user.childSnapshot(forPath: "email").value as! String
                if usernames.contains(email) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func getEmailsFor(group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { userSnapshot in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { groupSnapshot in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains(Auth.auth().currentUser!.uid) {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description") as! String
                    
                    let group = Group(title: title, description: description, key: group.key, members: memberArray, memberCount: memberArray.count)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
}
