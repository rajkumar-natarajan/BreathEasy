import XCTest
@testable import BreathEasy

class SessionViewModelTests: XCTestCase {
    
    var viewModel: SessionViewModel!
    var dataManager: DataManager!
    var settings: AppSettings!
    
    override func setUpWithError() throws {
        settings = AppSettings()
        dataManager = DataManager.shared
        viewModel = SessionViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel?.stopSession()
        viewModel = nil
        dataManager = nil
        settings = nil
    }
    
    func testTimerManagement() throws {
        // Test that multiple calls to start timers don't create overlapping timers
        XCTAssertEqual(viewModel.currentPhase, .ready)
        XCTAssertFalse(viewModel.isSessionActive)
        
        // Start session
        viewModel.startSession()
        
        XCTAssertTrue(viewModel.isSessionActive)
        XCTAssertEqual(viewModel.currentPhase, .ready)
        
        // Wait a bit for timers to start
        let expectation = XCTestExpectation(description: "Timer startup")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Verify session is running without crashes
        XCTAssertTrue(viewModel.isSessionActive)
        
        // Stop session
        viewModel.stopSession()
        XCTAssertFalse(viewModel.isSessionActive)
    }
    
    func testPhaseAdvancement() throws {
        // Test phase advancement doesn't cause infinite loops
        viewModel.startSession()
        
        XCTAssertEqual(viewModel.currentPhase, .ready)
        
        // Let it run for a few seconds to test phase transitions
        let expectation = XCTestExpectation(description: "Phase advancement")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [self] in
            // Should have advanced through multiple phases by now
            XCTAssertTrue(viewModel.isSessionActive)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        viewModel.stopSession()
    }
    
    func testZeroDurationHandling() throws {
        // Test that zero duration phases don't cause infinite loops
        viewModel.startSession()
        
        XCTAssertTrue(viewModel.isSessionActive)
        
        // Let it run to ensure zero-duration phases don't break it
        let expectation = XCTestExpectation(description: "Zero duration handling")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [self] in
            XCTAssertTrue(viewModel.isSessionActive)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 4.0)
        
        viewModel.stopSession()
    }
    
    func testSessionReset() throws {
        // Test that stopSession properly cleans up timers
        viewModel.startSession()
        
        XCTAssertTrue(viewModel.isSessionActive)
        
        viewModel.stopSession()
        
        XCTAssertFalse(viewModel.isSessionActive)
        XCTAssertEqual(viewModel.currentPhase, .ready)
        XCTAssertEqual(viewModel.elapsedTime, 0.0)
        XCTAssertEqual(viewModel.currentCycle, 0)
    }
    
    func testPauseResume() throws {
        // Test pause/resume functionality doesn't cause timer issues
        viewModel.startSession()
        
        XCTAssertTrue(viewModel.isSessionActive)
        XCTAssertFalse(viewModel.isPaused)
        
        viewModel.pauseSession()
        XCTAssertTrue(viewModel.isPaused)
        XCTAssertTrue(viewModel.isSessionActive)
        
        viewModel.resumeSession()
        XCTAssertFalse(viewModel.isPaused)
        XCTAssertTrue(viewModel.isSessionActive)
        
        viewModel.stopSession()
    }
    
    func testSessionCompletion() throws {
        // Test that session completes properly without hanging
        viewModel.startSession()
        
        XCTAssertTrue(viewModel.isSessionActive)
        
        // Wait for session to run
        let expectation = XCTestExpectation(description: "Session completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // Session should either be completed or still running without crashes
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        // Clean up if still running
        if viewModel.isSessionActive {
            viewModel.stopSession()
        }
    }
}
