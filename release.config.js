module.exports = {
    repositoryUrl: "git@github.com:clanktron/scratchpad",
    branches: ['main'],
    tagFormat: "${version}",
    ci: false,
    plugins: [
        '@semantic-release/commit-analyzer',
        '@semantic-release/release-notes-generator'
    ]
}
