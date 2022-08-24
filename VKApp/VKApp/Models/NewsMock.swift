//
//  NewsMock.swift
//  VKApp
//
//  Created by Artem Mayer on 21.08.22.
//

import Foundation

struct NewsMock {
    enum Kind: String {
        case text = "NewsText"
        case image = "NewsImage"
        case video = "NewsVideo"
        case audio = "NewsAudio"
        case textImage
        case textVideo
        case textAudio
        case imageVideo
        case imageAudio
        case videoAudio
        case textImageVideo
        case textImageAudio
        case textVideoAudio
        case imageVideoAudio
        case textImageVideoAudio

        var rawValue: [String] {
            switch self {
            case .text, .image, .video, .audio:
                return [self.rawValue]
            case .textImage:
                return [Kind.text.rawValue, Kind.image.rawValue]
            case .textVideo:
                return [Kind.text.rawValue, Kind.video.rawValue]
            case .textAudio:
                return [Kind.text.rawValue, Kind.audio.rawValue]
            case .imageVideo:
                return [Kind.image.rawValue, Kind.video.rawValue]
            case .imageAudio:
                return [Kind.image.rawValue, Kind.audio.rawValue]
            case .videoAudio:
                return [Kind.video.rawValue, Kind.audio.rawValue]
            case .textImageVideo:
                return [Kind.text.rawValue, Kind.image.rawValue, Kind.video.rawValue]
            case .textImageAudio:
                return [Kind.text.rawValue, Kind.image.rawValue, Kind.audio.rawValue]
            case .textVideoAudio:
                return [Kind.text.rawValue, Kind.video.rawValue, Kind.audio.rawValue]
            case .imageVideoAudio:
                return [Kind.image.rawValue, Kind.video.rawValue, Kind.audio.rawValue]
            case .textImageVideoAudio:
                return [Kind.text.rawValue, Kind.image.rawValue, Kind.video.rawValue, Kind.audio.rawValue]
            }
        }
    }

    let user: UserTestData?
    let postingDate: String?
    var text: String?
    var images: PhotoTestData?
    var audio: String?
    var video: String?
    var numberOfViews: Int?
    var numberOfLikes: Int?
    var numberOfComments: Int?
    var numberOfShares: Int?

    var postType: Kind? {
        let hasText = text != nil
        let hasImage = images != nil
        let hasVideo = video != nil
        let hasAudio = audio != nil

        switch (hasText, hasImage, hasVideo, hasAudio) {
        case (true, false, false, false): return .text
        case (false, true, false, false): return .image
        case (false, false, true, false): return .video
        case (false, false, false, true): return .audio
        case (true, true, false, false): return .textImage
        case (true, false, true, false): return .textVideo
        case (true, false, false, true): return .textAudio
        case (false, true, true, false): return .imageVideo
        case (false, true, false, true): return .imageAudio
        case (false, false, true, true): return .videoAudio
        case (true, true, true, false): return .textImageVideo
        case (true, true, false, true): return .textImageAudio
        case (true, false, true, true): return .textVideoAudio
        case (false, true, true, true): return .imageVideoAudio
        case (true, true, true, true): return .textImageVideoAudio
        default: return nil
        }
    }

    private init(user: UserTestData,
                 postingDate: String,
                 text: String? = nil,
                 photos: PhotoTestData? = nil,
                 audio: String? = nil,
                 video: String? = nil,
                 numberOfViews: Int? = nil,
                 numberOfLikes: Int? = nil,
                 numberOfComments: Int? = nil,
                 numberOfShares: Int? = nil)
    {
        self.user = user
        self.postingDate = postingDate
        self.text = text
        self.images = photos
        self.audio = audio
        self.video = video
        self.numberOfViews = numberOfViews
        self.numberOfLikes = numberOfLikes
        self.numberOfComments = numberOfComments
        self.numberOfShares = numberOfShares
    }
}

extension NewsMock: NewsCellTypeDataProtocol {
    static var news = [NewsMock(user: UserTestData.users[0],
                                postingDate: "09.04.2022 20:38",
                                text: "Есть над чем задуматься: диаграммы связей лишь добавляют фракционных разногласий и подвергнуты целой серии независимых исследований. Господа, понимание сути ресурсосберегающих технологий предполагает независимые способы реализации распределения внутренних резервов и ресурсов. Но глубокий уровень погружения способствует подготовке и реализации анализа существующих паттернов поведения. Но акционеры крупнейших компаний объявлены нарушающими общечеловеческие нормы этики и морали. Сложно сказать, почему базовые сценарии поведения пользователей смешаны с не уникальными данными до степени совершенной неузнаваемости, из-за чего возрастает их статус бесполезности. Картельные сговоры не допускают ситуации, при которой некоторые особенности внутренней политики лишь добавляют фракционных разногласий и своевременно верифицированы. Лишь элементы политического процесса, которые представляют собой яркий пример континентально-европейского типа политической культуры, будут заблокированы в рамках своих собственных рациональных ограничений!",
                                numberOfViews: 3),
                       NewsMock(user: UserTestData.users[1],
                                postingDate: "09.04.2022 21:47",
                                photos: PhotoTestData.photos[0],
                                numberOfLikes: 32),
                       NewsMock(user: UserTestData.users[2],
                                postingDate: "09.04.2022 22:01",
                                audio: "АУДИО: Ludovico Einaudi — Una Mattina",
                                numberOfComments: 98),
                       NewsMock(user: UserTestData.users[3],
                                postingDate: "09.04.2022 22:05",
                                video: "ВИДЕО: Настройка MacBook для новичков: 20+ полезных фишек macOS",
                                numberOfShares: 27),
                       NewsMock(user: UserTestData.users[4],
                                postingDate: "09.04.2022 22:06",
                                text: "Но начало повседневной работы по формированию позиции говорит о возможностях системы массового участия. В целом, конечно, высококачественный прототип будущего проекта прекрасно подходит для реализации экспериментов, поражающих по своей масштабности и грандиозности. И нет сомнений, что диаграммы связей, вне зависимости от их уровня, должны быть преданы социально-демократической анафеме. Принимая во внимание показатели успешности, реализация намеченных плановых заданий прекрасно подходит для реализации новых предложений.",
                                photos: PhotoTestData.photos[1],
                                numberOfViews: 45,
                                numberOfLikes: 22),
                       NewsMock(user: UserTestData.users[6],
                                postingDate: "09.04.2022 22:07",
                                text: "Undoubtedly, the strengthening and development of the internal structure directly depends on the new principles for the formation of the material, technical and personnel base. Being only part of the overall picture, the key features of the project's structure are ambiguous and will be anathematized by the social democratic.",
                                audio: "АУДИО: Bonobo — All In Forms",
                                numberOfViews: 2983,
                                numberOfComments: 34),
                       NewsMock(user: UserTestData.users[4],
                                postingDate: "09.04.2022 22:09",
                                text: "Приятно, граждане, наблюдать, как сделанные на базе интернет-аналитики выводы являются только методом политического участия и ограничены исключительно образом мышления.",
                                video: "ВИДЕО: Морские Легенды: USS Hornet",
                                numberOfViews: 344,
                                numberOfShares: 22),
                       NewsMock(user: UserTestData.users[7],
                                postingDate: "09.04.2022 22:10",
                                photos: PhotoTestData.photos[2],
                                audio: "АУДИО: Martin Jacoby - Opening",
                                numberOfLikes: 44,
                                numberOfComments: 2),
                       NewsMock(user: UserTestData.users[8],
                                postingDate: "09.04.2022 22:11",
                                photos: PhotoTestData.photos[3],
                                video: "ВИДЕО: Пропавшие в горах Крыма. Трагедии",
                                numberOfLikes: 28475,
                                numberOfShares: 7643),
                       NewsMock(user: UserTestData.users[7],
                                postingDate: "09.04.2022 22:12",
                                audio: "АУДИО: The Best Pessimist - Above the Fog",
                                video: "ВИДЕО: В ожидании рейса ...",
                                numberOfComments: 632,
                                numberOfShares: 8),
                       NewsMock(user: UserTestData.users[1],
                                postingDate: "09.04.2022 22:12",
                                text: "Не следует, однако, забывать, что выбранный нами инновационный путь создаёт предпосылки для дальнейших направлений развития.",
                                photos: PhotoTestData.photos[4],
                                audio: "АУДИО: Tycho - Red Bridge",
                                numberOfViews: 461,
                                numberOfLikes: 358,
                                numberOfComments: 128),
                       NewsMock(user: UserTestData.users[2],
                                postingDate: "09.04.2022 22:24",
                                text: "В целом, конечно, высокотехнологичная концепция общественного уклада однозначно определяет каждого участника как способного принимать собственные решения касаемо экономической целесообразности принимаемых решений. Сложно сказать, почему непосредственные участники технического прогресса, вне зависимости от их уровня, должны быть смешаны с не уникальными данными до степени совершенной неузнаваемости, из-за чего возрастает их статус бесполезности. Идейные соображения высшего порядка, а также глубокий уровень погружения предоставляет широкие возможности для существующих финансовых и административных условий. А ещё ключевые особенности структуры проекта ограничены исключительно образом мышления. Разнообразный и богатый опыт говорит нам, что сплочённость команды профессионалов не оставляет шанса для переосмысления внешнеэкономических политик. Господа, консультация с широким активом не даёт нам иного выбора, кроме определения системы обучения кадров, соответствующей насущным потребностям. Современные технологии достигли такого уровня, что граница обучения кадров предполагает независимые способы реализации глубокомысленных рассуждений.",
                                photos: PhotoTestData.photos[5],
                                video: "ВИДЕО: Последние минуты жизни остались на фото",
                                numberOfViews: 653,
                                numberOfLikes: 438,
                                numberOfShares: 234),
                       NewsMock(user: UserTestData.users[7],
                                postingDate: "09.04.2022 22:37",
                                text: "И нет сомнений, что интерактивные прототипы неоднозначны и будут подвергнуты целой серии независимых исследований.",
                                audio: "АУДИО: Kiasmos - Looped",
                                video: "ВИДЕО: Кому не стоит идти в программисты? Причины",
                                numberOfViews: 54,
                                numberOfComments: 23,
                                numberOfShares: 12),
                       NewsMock(user: UserTestData.users[5],
                                postingDate: "09.04.2022 22:49",
                                photos: PhotoTestData.photos[6],
                                audio: "АУДИО: Spicules - Red Lights Are Setting",
                                video: "ВИДЕО: Катастрофа \"Александа Суворова\". Мясорубка на Волге",
                                numberOfLikes: 2,
                                numberOfComments: 1,
                                numberOfShares: 1),
                       NewsMock(user: UserTestData.users[9],
                                postingDate: "09.04.2022 22:51",
                                text: "Как уже неоднократно упомянуто, элементы политического процесса набирают популярность среди определенных слоев населения, а значит, должны быть в равной степени предоставлены сами себе.",
                                photos: PhotoTestData.photos[7],
                                audio: "АУДИО: Actress, Sampha - Walking Flames",
                                video: "ВИДЕО: Джем - RIOPY: I love you (solo piano)",
                                numberOfViews: 987,
                                numberOfLikes: 765,
                                numberOfComments: 543,
                                numberOfShares: 321),
                       NewsMock(user: UserTestData.users[10],
                                postingDate: "09.04.2022 23:00"),
                       NewsMock(user: UserTestData.users[10],
                                postingDate: "09.04.2022 23:01",
                                numberOfViews: 2),
                       NewsMock(user: UserTestData.users[10],
                                postingDate: "09.04.2022 23:00",
                                text: "Как принято считать, активно развивающиеся страны третьего мира представляют собой не что иное, как квинтэссенцию победы маркетинга над разумом и должны быть преданы социально-демократической анафеме.")]
}
