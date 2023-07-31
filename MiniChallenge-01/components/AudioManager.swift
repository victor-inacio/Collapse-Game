import AVFAudio

class AudioManager {
    
    static var generalVolume: Float = 1
    private var player: AVAudioPlayer!
    
    static var players: [AudioManager] = []

    init(fileName: String) {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        guard let soundFileURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Arquivo de som não encontrado.")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: soundFileURL)
            player.volume = AudioManager.generalVolume
            
            AudioManager.players.append(self)
        } catch {
            print("Erro ao reproduzir o som: (error.localizedDescription)")
        }
    }
    
    func setVolume(volume: Float, interval: TimeInterval = 0) -> Self {
        player.setVolume(volume * AudioManager.generalVolume, fadeDuration: interval)
        
        return self
    }
    
    func setLoops(loops: Int) -> Self {
        self.player.numberOfLoops = loops
        
        return self
    }
    
    func play() -> Self {
        player.prepareToPlay()
        player.play()
        
        return self
    }
    
    
    static func toggleMute() {
        AudioManager.generalVolume = AudioManager.generalVolume == 1 ? 0 : 1
        
        AudioManager.players.forEach { audio in
            audio.setVolume(volume: AudioManager.generalVolume)
        }
    }
}

