import Foundation
import Nimble
import Quick

@testable import Broad

class GraphAPIClientSpec: QuickSpec {
    
    override func spec() {
        describe("GitURL") {
            it("gets result") {
                var data: GraphChannelResponse? = nil
                
                GraphAPIClient().latest()
                    .startWithResult { result in
                        switch (result) {
                        case .success(let result):
                            data = result
                        case .failure(let err):
                            print(err)
                            fail("Request Failed")
                        }
                }
                
                expect(data).toEventuallyNot(beNil(), timeout: DispatchTimeInterval.seconds(3))
            }
        }
    }
    
}
