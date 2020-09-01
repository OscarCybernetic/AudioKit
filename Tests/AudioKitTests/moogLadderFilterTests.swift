// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit

class MoogLadderFilterTests: AKTestCase {

    override func setUp() {
        super.setUp()
        duration = 1.0
    }

    func testDefault() {
        engine.output = AKOperationEffect(input) { $0.moogLadderFilter() }
        AKTest()
    }

}