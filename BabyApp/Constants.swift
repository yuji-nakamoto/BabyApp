//
//  Constants.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/28.
//

import Foundation
import Firebase

public let COLLECTION_USERS = Firestore.firestore().collection("users")
public let COLLECTION_TWEET = Firestore.firestore().collection("tweet")
public let COLLECTION_FOLLOW = Firestore.firestore().collection("follow")
public let COLLECTION_FOLLOWER = Firestore.firestore().collection("follower")
public let COLLECTION_FEED = Firestore.firestore().collection("feed")
public let COLLECTION_INQUIRY = Firestore.firestore().collection("inquiry")
public let COLLECTION_OPINION = Firestore.firestore().collection("opinion")
public let COLLECTION_REPORT = Firestore.firestore().collection("report")
public let COLLECTION_BLOCK = Firestore.firestore().collection("block")

public let O_BLACK = "original_black"
public let O_GREEN = "original_green"
public let O_RED = "original_red"
public let O_BLUE = "original_blue"
public let O_NAVY1 = "original_navy1"
public let O_NAVY2 = "original_navy2"

public let UID = "uid"
public let USERNAME = "username"
public let EMAIL = "email"
public let PROFILE_IMAGE_URL = "profileImageUrl"
public let AGE = "age"
public let SELFINTRO = "selfIntro"
public let INQUIRY = "inquiry"
public let OPINION = "opinion"
public let COMMUNITY_BADGE_COUNT = "communityBadgeCount"
public let MYPAGE_BADGE_COUNT = "myPageBadgeCount"
public let APP_BADGE_COUNT = "appBadgeCount"

public let FROM = "from"
public let TO = "to"
public let REPORT = "report"

public let ISBLOCK = "isBlock"

public let TWEETID = "tweetId"
public let DATE = "date"
public let DATE2 = "date2"
public let TEXT = "text"
public let CONTENTS_IMAGE_URL = "contentsImageUrl"
public let LIKECOUNT = "likeCount"
public let TIMESTAMP = "timestamp"
public let COMMENT = "comment"
public let COMMENTCOUNT = "commentCount"
public let COMMENTID = "commentId"

public let IS_FOLLOW = "isFollow"
public let FOLLOW_COUNT = "followCount"
public let IS_FOLLOWER = "isFollower"
public let FOLLOWER_COUNT = "followerCount"

public let ON_REFRESH = "onRefresh"
public let ON_HUD = "onHud"
public let ON_MYPAGE = "onMyPage"
public let REFRESH = "refresh"
public let IS_LOGIN = "isLogin"
public let SOUND_RELOAD1 = "soundReload1"
public let SOUND_RELOAD2 = "soundReload2"
public let SOUND_RELOAD3 = "soundReload3"
public let SOUND_RELOAD4 = "soundReload4"

public let END_TUTORIAL = "endTutorial"
public let SHOW_BANNER = "showBanner"
public let PUSH_FOLLOW = "pushFollow"
public let PUSH_POST = "pushPost"

public let FAVO_SLEEP1 = "favoSLEEP1"
public let FAVO_SLEEP2 = "favoSLEEP2"
public let FAVO_SLEEP3 = "favoSLEEP3"
public let FAVO_SLEEP4 = "favoSLEEP4"
public let FAVO_SLEEP5 = "favoSLEEP5"
public let FAVO_SLEEP6 = "favoSLEEP6"
public let FAVO_SLEEP7 = "favoSLEEP7"
public let FAVO_SLEEP8 = "favoSLEEP8"
public let FAVO_SLEEP9 = "favoSLEEP9"
public let FAVO_SLEEP10 = "favoSLEEP10"

public let FAVO_FUN1 = "favoFun1"
public let FAVO_FUN2 = "favoFun2"
public let FAVO_FUN3 = "favoFun3"
public let FAVO_FUN4 = "favoFun4"
public let FAVO_FUN5 = "favoFun5"
public let FAVO_FUN6 = "favoFun6"
public let FAVO_FUN7 = "favoFun7"
public let FAVO_FUN8 = "favoFun8"
public let FAVO_FUN9 = "favoFun9"

public let FAVO_ANIMAL1 = "favoAnimal1"
public let FAVO_ANIMAL2 = "favoAnimal2"
public let FAVO_ANIMAL3 = "favoAnimal3"
public let FAVO_ANIMAL4 = "favoAnimal4"
public let FAVO_ANIMAL5 = "favoAnimal5"
public let FAVO_ANIMAL6 = "favoAnimal6"
public let FAVO_ANIMAL7 = "favoAnimal7"
public let FAVO_ANIMAL8 = "favoAnimal8"
public let FAVO_ANIMAL9 = "favoAnimal9"

public let FAVO_NATURE1 = "favoNature1"
public let FAVO_NATURE2 = "favoNature2"
public let FAVO_NATURE3 = "favoNature3"
public let FAVO_NATURE4 = "favoNature4"
public let FAVO_NATURE5 = "favoNature5"
public let FAVO_NATURE6 = "favoNature6"
public let FAVO_NATURE7 = "favoNature7"
public let FAVO_NATURE8 = "favoNature8"
public let FAVO_NATURE9 = "favoNature9"
public let FAVO_NATURE10 = "favoNature10"
public let FAVO_NATURE11 = "favoNature11"

public let ADD_FAVO = "addFavo"

public let PLACEHOLDER_IMAGE_URL = "https://firebasestorage.googleapis.com/v0/b/datingapp-d0f98.appspot.com/o/images%2F2EB76E60-16FA-494F-9419-19905F13553C?alt=media&token=3c8906ed-1a5e-4370-8270-432dc0431ae5"
