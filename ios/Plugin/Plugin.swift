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
        let localPalyer = GKLocalPlayer.local
        
        localPalyer.authenticateHandler = { vc, error in
            // If the local player isn’tt signed in to Game Center on the device, GameKit passes a view controller
            // that implements the sign-in interface that you present to the player.
            if let vc = vc {
                DispatchQueue.main.async {
                    self.bridge.viewController.present(vc, animated: true)
                }
            } else if localPalyer.isAuthenticated {
                // If the player successfully signs in, GameKit sets the local player’s isAuthenticated property to true
                // and calls the handler again, this time passing nil for both the view controller and error parameters.
                if (vc == nil && error == nil) {
                    print("[GameServices] local player is authenticated")
                    let result = [
                        "response": [
                            "player_name": localPalyer.displayName,
                            "player_id": localPalyer.gamePlayerID,
                        ]
                    ]
                    call.resolve(result as PluginResultData)
                }
            } else {
                // If the player decides not to sign in or create a Game Center account, GameKit sets the local player’s 
                // isAuthenticated property to false and calls the handler again by passing an error that indicates
                // the reason the player isn’t authenticated. In this case, disable Game Center in your game.
                call.reject("[GameServices] local player is not authenticated")
            }
        }
    }
    
    @objc func showLeaderboard(_ call: CAPPluginCall) {
        self.call = call
        let result = [
            "response": []
        ]
        DispatchQueue.main.async {
            let vc = GKGameCenterViewController()
            vc.gameCenterDelegate = self
            vc.viewState = .leaderboards
            vc.leaderboardIdentifier = call.getString("leaderboardId")
            self.bridge.viewController.present(vc, animated: true, completion: {() -> Void in
                print("[GameServices] Achievement is about to present")
                call.resolve(result as PluginResultData)
            })
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
            self.bridge.viewController.present(vc, animated: true, completion: {() -> Void in
                print("[GameServices] Achievement is about to present")
                call.resolve(result as PluginResultData)
            })
        }
    }
    
    @objc func submitScore(_ call: CAPPluginCall) {
        self.call = call
        let result = [
            "response": []
        ]
        // default not working!!!
        let leaderboardId = call.getString("leaderboardId") ?? "testLeaderboard" // for these defaults, have a default leaderboard set here? instead of setting a players default leaderboard??
        
        // TODO: is there any additional error handling here?
        let score = Int64(call.getInt("score") ?? 0) // TODO: test what happens when expects an Integer but gets booleans, or even a string
        print("[GameServices] Sumbitting Score \(score) to leaderboard id \(leaderboardId)")
        
        let newScore = GKScore(leaderboardIdentifier: leaderboardId)
        newScore.value = score
        
        GKScore.report([newScore]) { error in
            guard error == nil else {
                let errorMessage = "[GameServices] \(error?.localizedDescription ?? "")"
                print(errorMessage)
                call.reject(errorMessage)
                return
            }
            let successMessage = "[GameServices] Report Score Success"
            print(successMessage)
            call.resolve(result as PluginResultData)
        }
    }
    
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
            call.resolve(result as PluginResultData)
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
            call.resolve(result as PluginResultData)
        }
    }
}
