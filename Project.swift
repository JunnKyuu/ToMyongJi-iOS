import ProjectDescription

let project = Project(
    name: "ToMyongJi",
    organizationName: "ToMyongJi",
    packages: [
        .remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "ToMyongJi-iOS",
            destinations: [.iPhone, .iPad],
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
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone, .ipad])
        ),
        .target(
            name: "App",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.tomyongji.app",
            infoPlist: .extendingDefault(with: [:]),
            sources: ["App/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "UI"),
                .target(name: "Feature")
            ],
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone, .ipad])
        ),
        .target(
            name: "Feature",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.tomyongji.feature",
            infoPlist: .extendingDefault(with: [:]),
            sources: ["Feature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "UI")
            ],
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone, .ipad])
        ),
        .target(
            name: "Core",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.tomyongji.core",
            infoPlist: .extendingDefault(with: [:]),
            sources: ["Core/Sources/**"],
            dependencies: [
                .package(product: "Alamofire")
            ],
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone, .ipad])
        ),
        .target(
            name: "UI",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.tomyongji.ui",
            infoPlist: .extendingDefault(with: [:]),
            sources: ["UI/Sources/**"],
            resources: [
                "UI/Resources/Assets.xcassets",
                "UI/Resources/Fonts/**"
            ],
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone, .ipad])
        )
    ]
)