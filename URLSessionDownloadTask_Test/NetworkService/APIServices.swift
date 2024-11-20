//
//  APIServices.swift
//  URLSessionDownloadTask_Test
//
//  Created by AbdulMajid Shaikh on 16/11/24.
//

import Foundation

public class APIServices {
    
    static let urlTopic1 = "\(baseURL)\(endPointTopic1)"
    static let urlTopic2 = "\(baseURL)\(endPointTopic2)"
    static let urlTopic3 = "\(baseURL)\(endPointTopic3)"
    
    
    static let baseURL = "https://navreports.blob.core.windows.net/navtestmedia/"
    
    static let endPointTopic1 = "topic1.zip?sp=r&st=2024-11-09T13:34:18Z&se=2025-12-30T21:34:18Z&spr=https&sv=2022-11-02&sr=b&sig=cRvxEpizK1Z9B0kys8Psk%2FwL3kOPicy%2B0FKraDbKjCk%3D"
    static let endPointTopic2 = "topic2.zip?sp=r&st=2024-11-09T13:34:59Z&se=2025-12-30T21:34:59Z&spr=https&sv=2022-11-02&sr=b&sig=xTfY1Vh15FekUvD3QOI2mq45hIp6utyrhdscf6f2Nuw%3D"
    static let endPointTopic3 = "topic3.zip?sp=r&st=2024-11-09T13:35:23Z&se=2025-12-30T21:35:23Z&spr=https&sv=2022-11-02&sr=b&sig=iWrw6FtIqG9mESIDEw2DtLXe%2BC4Be4ieZerdbv8DoOk%3D"
}
