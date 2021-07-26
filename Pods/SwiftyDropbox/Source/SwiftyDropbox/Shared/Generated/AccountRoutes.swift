///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

/// Routes for the account namespace
open class AccountRoutes {
    public let client: DropboxTransportClient
    init(client: DropboxTransportClient) {
        self.client = client
    }

    /// Sets a user's profile photo.
    ///
    /// - parameter photo: Image to set as the user's new profile photo.
    ///
    ///  - returns: Through the response callback, the caller will receive a `Account.SetProfilePhotoResult` object on
    /// success or a `Account.SetProfilePhotoError` object on failure.
    @discardableResult open func setProfilePhoto(photo: Account.PhotoSourceArg) -> RpcRequest<Account.SetProfilePhotoResultSerializer, Account.SetProfilePhotoErrorSerializer> {
        let route = Account.setProfilePhoto
        let serverArgs = Account.SetProfilePhotoArg(photo: photo)
        return client.request(route, serverArgs: serverArgs)
    }

}
