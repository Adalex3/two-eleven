//
//  CloudKit.swift
//  Abuse Helper
//
//  Created by Alex Hynds on 10/22/22.
//

import SwiftUI
import CloudKit

class CloudKitViewModel: ObservableObject {
    
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    
    init() {
        getiCloudStatus()
        fetchiCloudUserRecordID()
    }
    
    private func getiCloudStatus() {
        CKContainer.default().accountStatus { [weak self] returnedStatus, returnedError in DispatchQueue.main.async {
            switch returnedStatus {
            case .available:
                self?.isSignedInToiCloud = true
            case .noAccount:
                self?.error = CloudKitError.iCloudAccountNotFound.localizedDescription
            case .couldNotDetermine:
                self?.error = CloudKitError.iCloudAccountNotDetermined.localizedDescription
            case .restricted:
                self?.error = CloudKitError.iCloudAccountRestricted.localizedDescription
            default:
                self?.error = CloudKitError.iCloudAccountUnknown.localizedDescription
            }
        }
        }
    }
    enum CloudKitError: LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
    }
    
    func fetchiCloudUserRecordID() {
        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
            if let id = returnedID {
                self?.discoveriCloudUser(id: id)
            }
        }
    }
    
    func discoveriCloudUser(id: CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in DispatchQueue.main.async{
            if let name = returnedIdentity?.nameComponents?.givenName {
                self?.userName = name
                print(name)
            }
        }
        }
    }
}
