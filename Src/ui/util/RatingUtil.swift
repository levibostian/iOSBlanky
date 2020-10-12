import Foundation

// Set of utils for helping calculate and display ratings.
class RatingUtil {
    // Input: 1, 5 ("1 out of 5 star rating")
    // Output: [true, false, false, false, false]
    static func getRatingArray(rating: Int, outof max: Int) -> [Bool] {
        var ratingArray: [Bool] = []

        for index in 0 ..< max {
            let isPartOfRating = rating > index

            ratingArray.append(isPartOfRating)
        }

        return ratingArray
    }
}
