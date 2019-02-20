//
//  DatabaseManager.swift
//  FRAMEi
//
//  Created by JongHyeok on 09/01/2019.
//  Copyright © 2019 JongHyeok. All rights reserved.
//

import UIKit


class DatabaseManager{
    
    var dbPath: String?
    var db: OpaquePointer?
    
    //create database if not exists.
    init() {
        //check Database path and crate path.
        let fileMgr = FileManager()
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first! //document folder.
        
        //create backupPath if not exists.
        let backupFilePath = "MM/backup"
        let backupPath =  docPathURL.appendingPathComponent("\(backupFilePath)")
        if !FileManager.default.fileExists(atPath: backupPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: backupPath.path, withIntermediateDirectories: true, attributes: nil)
                print("Create backup path succeed")
            } catch {
                print("Couldn't create document backup directory")
            }
        }
        print("Document directory is \(backupPath)")
        
        //set database path.
        dbPath = backupPath.appendingPathComponent("Database.db").path
        
        
        
        // dbPath 경로에 파일이 없다면 앱 번들의 db.sqlite를 가져와 복사
        if fileMgr.fileExists(atPath: dbPath!) == false {
            let dbSource = Bundle.main.path(forResource: "Database", ofType: "db")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath!)
            print("db saved!")
        }else{
            print("already db saved!")
        }
        
    }
    
    
    //open database
    private func openDatabase() -> OpaquePointer? {
        var dbm: OpaquePointer? = nil
        if sqlite3_open(dbPath!, &dbm) == SQLITE_OK {
            //print("Successfully opened connection to database at \(dbPath!)")
            return dbm
        } else {
           // print("Unable to open database. Verify that you created the directory described in the Getting Started section.")
            
            return nil
        }
    }
    
    
    
    
    //ready for database.
    func initDatabase(){
        
        //start db.
        db = openDatabase()
    }
    
    
    //cloase db connection.
    func closeDatabase(){
        sqlite3_close(db)
    }
    
    
    
    //insert data.
    func insertCardData(cardID: NSString, imagePath: NSString, title: NSString, date: NSString, content: NSString?, location: NSString?) {
        
        var insertStatement: OpaquePointer? = nil
        let insertStatementString = "INSERT INTO cardList (time_id, img, title, date, content, location) VALUES (?, ?, ?, ?, ?, null);"
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            //insert data.
            sqlite3_bind_text(insertStatement, 1, cardID.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, imagePath.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, title.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, date.utf8String, -1, nil)
            
            if content == nil{
                let bank: NSString = ""
                sqlite3_bind_text(insertStatement, 5, bank.utf8String, -1, nil)
            }else{
                sqlite3_bind_text(insertStatement, 5, content!.utf8String, -1, nil)
            }
            
            
            
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    
    
    //update card data.
    func updateCard(originalCardID: NSString, title: NSString, date: NSString, content: NSString?, location: NSString?) {
        
        var updateStatement: OpaquePointer? = nil
        var updateStatementString: String?
        if content == nil{
            updateStatementString = "UPDATE cardList SET title = '\(title)', date = '\(date)', content = '' WHERE time_id = '\(originalCardID)';"
        }else{
            updateStatementString = "UPDATE cardList SET title = '\(title)', date = '\(date)', content = '\(content!)' WHERE time_id = '\(originalCardID)';"
        }
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    
    //delete card data.
    func deleteCard(originalCardID: NSString) {
        var deleteStatement: OpaquePointer? = nil
        let deleteStatementStirng = "DELETE FROM cardList WHERE time_id = '\(originalCardID)';"
        
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    
    
    //get card data.
    func getAllCardData() -> Array<cardItem> {
        
        var cardlist = [cardItem]()
        
        var queryStatement: OpaquePointer? = nil
        let queryStatementString = "SELECT * FROM cardList;"
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                
                
                let getCardIdQuery = sqlite3_column_text(queryStatement, 0)
                let getCardId = String(cString: getCardIdQuery!)
                
                let getCardImageQuery = sqlite3_column_text(queryStatement, 1)
                let getCardImage = String(cString: getCardImageQuery!)
                
                let getCardTitleQuery = sqlite3_column_text(queryStatement, 2)
                let getCardTitle = String(cString: getCardTitleQuery!)
                
                let getCardDateQuery = sqlite3_column_text(queryStatement, 3)
                let getCardDate = String(cString: getCardDateQuery!)
                
                let getCardContentQuery = sqlite3_column_text(queryStatement, 4)
                let getCardContent = String(cString: getCardContentQuery!)
                
               // print("Query Result:")
               // print("\(getCardId) | \(getCardImage) | \(getCardTitle) | \(getCardDate) | \(getCardContent)")
                
                let oneCard = cardItem();
                oneCard.cardId = UInt(getCardId)
                oneCard.image = getCardImage
                oneCard.regdate = getCardDate
                oneCard.content = getCardContent
                oneCard.title = getCardTitle
                
                cardlist.append(oneCard)
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        
        
        sqlite3_finalize(queryStatement)
        
        
        return cardlist
    }
    
    
    
    //get card data.
    func getSelectedCardData() -> cardItem {
        
        let card = cardItem()
        
        var queryStatement: OpaquePointer? = nil
        let queryStatementString = "SELECT * FROM cardList;"
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let getCardIdQuery = sqlite3_column_text(queryStatement, 0)
                let getCardId = String(cString: getCardIdQuery!)
                
                let getCardImageQuery = sqlite3_column_text(queryStatement, 1)
                let getCardImage = String(cString: getCardImageQuery!)
                
                let getCardTitleQuery = sqlite3_column_text(queryStatement, 2)
                let getCardTitle = String(cString: getCardTitleQuery!)
                
                let getCardDateQuery = sqlite3_column_text(queryStatement, 3)
                let getCardDate = String(cString: getCardDateQuery!)
                
                let getCardContentQuery = sqlite3_column_text(queryStatement, 4)
                let getCardContent = String(cString: getCardContentQuery!)
                
                
                
                card.cardId = UInt(getCardId)
                card.image = getCardImage
                card.regdate = getCardDate
                card.content = getCardContent
                card.title = getCardTitle
                
                
                //print("Query Result:")
                //print("\(getCardId) | \(getCardImage) | \(getCardTitle) | \(getCardDate) | \(getCardContent)")
                
            } else {
                print("Query returned no results")
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
        
        return card
    }
    
}
