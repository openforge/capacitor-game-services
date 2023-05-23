import Foundation
import Capacitor
import GameKit
import AuthenticationServices

@available(iOS 13.0, *)
@objc(GameServices)
public class GameServices: CAPPlugin, GKGameCenterControllerDelegate {
    var call: CAPPluginCall?

    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
        
    @objc func signIn(_ call: CAPPluginCall) {
        self.call = call
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = { gcAuthVC, error in
            if localPlayer.isAuthenticated {
                print("User is authenticated to Game Center!")
                let result = [
                    "response": [
                        "player_name": localPlayer.displayName,
                        "player_id": localPlayer.gamePlayerID
                    ]
                ]
                call.resolve(result)
            } else if gcAuthVC != nil {
                self.bridge?.viewController?.present(gcAuthVC!, animated: true)
            } else {
                call.reject("[GameServices] local player is not authenticated")
            }
        }
    }
    
    @objc func showLeaderboard(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.call = call
            let leaderboardViewController = GKGameCenterViewController()
            leaderboardViewController.viewState = .leaderboards
            leaderboardViewController.leaderboardIdentifier = "openforge.rockthesteps.leaderboard.io"
            leaderboardViewController.gameCenterDelegate = self
            leaderboardViewController.leaderboardTimeScope = .allTime
            self.bridge?.viewController?.present(leaderboardViewController, animated: true, completion: nil)
        }
    }
    
    @objc func showAchievements(_ call: CAPPluginCall) {
        self.call = call
        let result = [
            "response": []
        ]
        print("[GameServices] Showing Achievements")
        DispatchQueue.main.async {
            let vc = GKGameCenterViewController()
            vc.gameCenterDelegate = self;
            vc.viewState = .achievements
            self.bridge?.viewController?.present(vc, animated: true, completion: {() -> Void in
                print("[GameServices] Achievement is about to present")
                call.resolve(result as PluginCallResultData)
            })
        }
    }
    
    @objc func submitScore(_ call: CAPPluginCall) {
        self.call = call
        
        let leaderboardId = call.getString("leaderboardId") // Property to get the leaderboard ID
        let score = Int64(call.getInt("score") ?? 0) // Property to get the total score to submit
        
        if GKLocalPlayer.local.isAuthenticated {
            let gkScore = GKScore(leaderboardIdentifier: "leaderBoardID")
            gkScore.value = score
            if #available(iOS 14.0, *) {
                GKLeaderboard.submitScore(Int(score), context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["openforge.rockthesteps.leaderboard.io"]) { error in call.reject("error submiting score")}
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
//    @objc func getUserScore(_ call: CAPPluginCall) {
//        self.call = call
//
//        let leaderboardID = call.getString("leaderboardId") // Property to get the leaderboard
//
//        let leaderboard = GKLeaderboard(players: nil)
//        leaderboard.playerScope = .global
//        leaderboard.timeScope = .allTime
//        leaderboard.identifier = leaderboardID
//        leaderboard.range = NSRange(location: 1, length: 1)
//
//        leaderboard.loadEntries { (scores, error) in
//            if let error = error {
//                call.reject("Failed to load the entries for the leaderboards", error.localizedDescription)
//            } else if let scores = scores {
//                if let topScore = scores.first {
//                    let totalScore = topScore.value
//                    print("Total score: \(totalScore)")
//                    call.resolve(totalScore)
//                }
//            }
//        }
//    }
    
    @objc func unlockAchievement(_ call: CAPPluginCall) {
        print("unlockAchievement:called")
        progressAchievementDelegate(call, 100.0)
    }
    
    @objc func progressAchievement(_ call: CAPPluginCall) {
        print("progressAchievement:called")
        progressAchievementDelegate(call, call.getDouble("percentComplete"))
    }
    
    @objc func resetAllAchievementProgress(_ call: CAPPluginCall) {
        self.call = call
        let result = [
            "response": []
        ]
        print("resetAllAchievementProgress:called")
        
        GKAchievement.resetAchievements(completionHandler: { error in
            guard error == nil else {
                let errorMessage = "[GameServices] \(error?.localizedDescription ?? "Some Achievements Error")"
                print(errorMessage)
                call.reject(errorMessage)
                return
            }
            print("[GameServices] Reset Achievement Called")
            call.resolve(result as PluginCallResultData)
        })
    }
    
    /**
     Success response here means nothing?????
     TODO: Test if ios game service can set achievement progress that is backwards?
     could do setValue on key progressComplete to possibly clean this reuse up
        logging is going to get messed up if reading values only in delegate
     
     need to have way to know when something fails
     
        this is throttled, not buffered, how should it be communicated that sequential calls to the same achievement wont register

     */
    private func progressAchievementDelegate(_ call: CAPPluginCall, _ percentComplete: Double?) {
        self.call = call
        let result = [
            "response": []
        ]
        let achievementId = call.getString("achievementId") ?? "";
        let progressComplete = percentComplete ?? 100.0
        
        print("[GameServices] Setting Achievement Percentage \(progressComplete)")
                        
        let newAchievement = GKAchievement(identifier: achievementId)
        newAchievement.showsCompletionBanner = true
        newAchievement.percentComplete = progressComplete
        
        GKAchievement.report([newAchievement]) { error in
            guard error == nil else {
                print("[GameServices] \(error?.localizedDescription ?? "")")
                call.reject("[GameServices] \(error?.localizedDescription ?? "")")
                return
            }
            let successMessage = "[GameServices] Achievement Progress Was Reported"
            print(successMessage)
            call.resolve(result as PluginCallResultData)
        }
    }
}
