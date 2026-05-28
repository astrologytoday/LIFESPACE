import Foundation

// MARK: - Question Arrays Per Module

let lightQuestions: [String] = [
    "Is your home primarily warm light?",
]

let innerWorkQuestions: [String] = [
    "Did you connect with your higher power?",
    "Did you meditate?",
    "Do you have a positive outlook on the future?",
    "Have you fasted in the last 30 days?",
    "Have you prayed or meditated in the last 7 days?",
    "Have you done any breathwork in the last 30 days?",
    "Did you practice gratitude?",
    "Have you spent time in nature in the last 30 days?",
    "Have your actions reflected your morals and values?"
]


let fitnessQuestions: [String] = [
    "Did you fulfill your workout goals?",
    "Have you been running or biking in the last 7 days?",
    "Have you done any high intensity physical training?",
    "Did you stretch?",
    "Did you maintain good posture?",
    "Did you lift anything heavy?",
    "Did you break a sweat?",
]

let eatingQuestions: [String] = [
    "Did you meet your dietary goals?",
    "Did you follow a healthy diet?",
    "Did you cook all your meals today?",
    "Did you drink at least six cups of water?",
    "Did you include slow-digesting carbohydrates in your diet?",
]


let sensoryQuestions: [String] = [
    "Did you brush your teeth?",
    "Did you wash all your dishes before going to bed?",
    "Did you get dressed?",
    "Did you listen to music?",
    "Have you flossed?",
    "Did you wash your face?",
    "Have you showered?",
    "Did you wear clothes that made you feel good about yourself?",
]

let purposeQuestions: [String] = [
    "Did you accomplish anything meaningful?",
    "Did you work on a project that excites you?",
    "Did you say no to something misaligned with your goals?",
    "Have you set goals?",
    "Are you on track to fulfill your goals?",
    "Did you do something that made you feel proud?",
    "Do you know what your top priority is for this week?",
    "Have you been improving your professional skills?",
    "Have you learned something new in the last 30 days that is related to your profession or life’s purpose?",
    "Have you volunteered for a cause that is important to you in the last 6 months?",
    "Do you feel you are paid fairly for the work you do?"
]

let activityQuestions: [String] = [
    "Did you engage in a personal hobby?",
    "Did you do anything just for fun?",
    "Did you laugh?",
    "Were you bored?",
    "Were you tired?",
    "Did you take a nap?",
    "Did you stay up late?",
    "Is your sleep schedule consistent?",
    "Do you feel you have a healthy work-life balance?",
]

let communityQuestions: [String] = [
    "Did you have a conversation with somebody?",
    "Did you offer kindness to somebody today?",
    "Did you strengthen any of your relationships?",
    "Did you participate in a group in any way?",
    "Did you reach out to anybody?",
    "Did you feel understood by someone?",
    "Did you listen to someone with your full attention?",
    "Did you maintain eye contact with others?",
    "Have you met someone new in the last 90 days?",
    "Have you spent time with a romantic partner in the last 90 days?",
    "Have you spent time with someone you enjoy spending time with in the last 90 days?"
]

let expressionQuestions: [String] = [
    "Did you do anything creative?",
    "In the last 30 days, did you share something you created?",
    "Were you imaginative?",
    "Did anything inspire you?",
    "Did you enter the FLOW state? (i.e., working on a task for more than two hours straight)",
    "Did you express your personality?",
    "Did you learn something that grows your creative abilities?",
    "Did you challenge yourself creatively?",
    "Have you appreciated art that is impactful for you in the last 30 days?"
]

let invertedQuestionsByModule: [LifespaceModule: Set<String>] = [
    .light: [
        "Did you spend more than four hours in front of screens?",
        "Did you spend a lot of time with the lights off?",
        "Is your home primarily cool light?",
        "Are your walls primarily white and bare?",
        "Did you use your computer or phone less than 60 minutes before bed?",
        "Did you fall asleep with a screen?",
        "Did you spend a lot of time around bare white walls?",
    ],
    .innerWork: [
        "Do you feel guilty?",
    ],
    .fitness: [
        "Were you sedentary most of the day?"
    ],
    .eating: [
        "Did you drink alcohol?",
        "Did you eat a lot of snacks?",
        "Did you eat after 7:00pm?"
    ],
    .sensory: [
        "Did you drink more than two caffeinated drinks?",
        "Did you take recreational drugs more than once in the past 30 days?",
        "Did you smoke marijuana more than once this week?",
        "Is your floor dirty?",
        "Are you in any kind of pain?",
        "Have you spent more than 4 hours looking at screens today?",
        "Did you fall asleep with a screen?",
    ],
    .purpose: [
        "Did you feel distracted today?",
        "Did you self-sabotage?"
    ],
    .activity: [
        "Were you bored?",
        "Were you tired?",
        "Did you take a nap?",
        "Did you stay up late?",
        "Did you use your phone or computer less than 30 minutes before bed?"
    ],
]
// MARK: - Combined Module-Based Dictionary

let questionBankByModule: [LifespaceModule: [String]] = [
    .light: lightQuestions,
    .innerWork: innerWorkQuestions,
    .fitness: fitnessQuestions,
    .eating: eatingQuestions,
    .sensory: sensoryQuestions,
    .purpose: purposeQuestions,
    .activity: activityQuestions,
    .community: communityQuestions,
    .expression: expressionQuestions,
]

