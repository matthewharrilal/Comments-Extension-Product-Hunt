//
//  ViewController.swift
//  Extension-Product-Hunt-API
//
//  Created by Matthew Harrilal on 9/21/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let network1 = Network()
        print(network1.networking())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

struct Comments {
    let body: String?
    init(body: String?) {
        self.body = body
    }
}
extension Comments: Decodable{
    enum additonalKeys: String,CodingKey {
        case body
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: additonalKeys.self)
        let body = try container.decodeIfPresent(String.self, forKey: .body)
        self.init(body: body)
    }
}

struct ArrayComments: Decodable {
    let comments: [Comments]
}

class Network {
    func networking() {
        let session = URLSession.shared
        var url = URL(string: "https://api.producthunt.com/v1/comments")
        let urlParams = ["search[featured]": "true",
                         "scope": "public"]
        url = url?.appendingQueryParameters(urlParams)
        var getRequest = URLRequest(url: url!)
        getRequest.httpMethod = "GET"
        getRequest.setValue("Bearer affc40d00605f0df370dbd473350db649b0c88a5747a2474736d81309c7d5f7b ", forHTTPHeaderField: "Authorization")
        getRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        getRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        getRequest.setValue("api.producthunt.com", forHTTPHeaderField: "Host")
        
        session.dataTask(with: getRequest) { (data, response, error) in
            if let data = data {
                let comments = try? JSONDecoder().decode(ArrayComments.self, from: data)
                print(comments)
            }
        }.resume()
    }
}

extension URL {
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}


extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}
