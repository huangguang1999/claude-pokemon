import SwiftUI

/// Renders a Pokemon from pixel grid data using Canvas
struct PokemonPixelArtView: View {
    let species: PokemonSpecies
    let size: CGFloat

    var body: some View {
        let grid = species.pixelGrid
        let pal = species.palette
        let rows = grid.count
        let cols = grid.first?.count ?? 8

        Canvas { context, canvasSize in
            let cellW = canvasSize.width / CGFloat(cols)
            let cellH = canvasSize.height / CGFloat(rows)

            for (row, line) in grid.enumerated() {
                for (col, ch) in line.enumerated() {
                    guard ch != ".", let rgb = pal[ch] else { continue }
                    let rect = CGRect(
                        x: CGFloat(col) * cellW,
                        y: CGFloat(row) * cellH,
                        width: cellW + 0.5,
                        height: cellH + 0.5
                    )
                    context.fill(Path(rect), with: .color(Color(red: rgb.r, green: rgb.g, blue: rgb.b)))
                }
            }
        }
        .frame(width: size, height: size)
    }
}
