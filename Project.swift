import ProjectDescription

// 서명 설정을 위한 Settings 객체
let settings: Settings = .settings(
    base: [:],
    configurations: [
        .release(name: "Release", settings: [
            "DEVELOPMENT_TEAM": "FN67GXC5GH", // 개발팀 ID
            "CODE_SIGN_STYLE": "Manual",
            "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.tomyongji.ios",
            "CODE_SIGN_IDENTITY": "Apple Distribution"
        ]),
        .debug(name: "Debug", settings: [:])
    ],
    defaultSettings: .recommended
)


let project = Project(
    name: "ToMyongJi",
    organizationName: "ToMyongJi",
    packages: [
        .remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        // MARK: - App Target
        .target(
            name: "ToMyongJi-iOS",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.tomyongji.ios",
            infoPlist: .file(path: "App/Resources/Info.plist"),
            sources: ["App/Sources/**"],
            resources: [
                "UI/Resources/Assets.xcassets",
                "UI/Resources/Fonts/**"
            ],
            dependencies: [
                .target(name: "Core"),
                .target(name: "Feature"),
                .target(name: "UI")
            ],
            settings: settings
        ),        
        .target(
            name: "App",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.tomyongji.app",
            infoPlist: .extendingDefault(with: [:]),
            sources: ["App/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "UI"),
                .target(name: "Feature")
            ]
        ),
        .target(
            name: "Feature",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.tomyongji.feature",
            infoPlist: .extendingDefault(with: [:]),
            sources: ["Feature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "UI")
            ]
        ),
        .target(
            name: "Core",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.tomyongji.core",
            infoPlist: .extendingDefault(with: [:]),
            sources: ["Core/Sources/**"],
            dependencies: [
                .package(product: "Alamofire")
            ]
        ),
        .target(
            name: "UI",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.tomyongji.ui",
            infoPlist: .extendingDefault(with: [:]),
            sources: ["UI/Sources/**"],
            resources: [
                "UI/Resources/Assets.xcassets",
                "UI/Resources/Fonts/**"
            ]
        ),
        
        // MARK: - Test Targets
        .target(
            name: "CoreTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "com.tomyongji.coreTests",
            infoPlist: .extendingDefault(with: [:]),
            sources: ["Core/Tests/**"],
            dependencies: [
                .target(name: "Core")
            ]
        ),
        .target(
            name: "FeatureTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "com.tomyongji.featureTests",
            infoPlist: .extendingDefault(with: [:]),
            sources: ["Feature/Tests/**"],
            resources: [
                "Feature/Tests/**/*.pdf"
            ],
            dependencies: [
                .target(name: "Feature")
            ]
        )
    ]
)