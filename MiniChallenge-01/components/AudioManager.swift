import AVFAudio

class AudioManager {
    
    static var generalVolume: Float = 1
    private var player: AVAudioPlayer!
    public var volume: Float {
        
        get {
            return self._volume
        }
        
        set {
            self._volume = newValue
        }
        
    }
    
    private var _volume: Float = 1
    
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
            print(error.localizedDescription)
        }
    }
    
    @discardableResult
    func setVolume(volume: Float, interval: TimeInterval = 0) -> Self {
        player.setVolume(volume * AudioManager.generalVolume, fadeDuration: interval)
        self.volume = volume
        return self
    }
    
    @discardableResult
    func setLoops(loops: Int) -> Self {
        self.player.numberOfLoops = loops
        
        return self
    }
    
    @discardableResult
    func play() -> Self {
        player.prepareToPlay()
        player.play()
        
        return self
    }
    
    
    static func toggleMute() {
        AudioManager.generalVolume = AudioManager.generalVolume == 1 ? 0 : 1
        
        AudioManager.players.forEach { audio in
            audio.player.setVolume(audio.volume * AudioManager.generalVolume, fadeDuration: 0)
        }
    }
}

