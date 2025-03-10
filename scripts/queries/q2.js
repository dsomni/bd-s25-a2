var db_name = "bd-a2";
db = connect(`mongodb://localhost/${db_name}`);

db.users.aggregate([
  {
    $unwind: "$events",
  },
  {
    $match: {
      "events.event_type": {
        $in: ["view", "cart", "purchase"],
      },
    },
  },
  {
    $group: {
      _id: {
        product_id: "$events.product_id",
        user_id: "$user_id",
      },
      total_interactions: {
        $sum: {
          $cond: [
            {
              $in: ["$events.event_type", ["view", "cart"]],
            },
            1,
            0,
          ],
        },
      },
      popularity: {
        $sum: 1,
      },
    },
  },
  {
    $group: {
      _id: "$_id.product_id",
      popularity: {
        $sum: "$popularity",
      },
      user_interaction_score: {
        $max: {
          $cond: [
            {
              $eq: ["$_id.user_id", "563016948"],
            },
            "$total_interactions",
            0,
          ],
        },
      },
    },
  },
  {
    $lookup: {
      from: "products",
      localField: "_id",
      foreignField: "product_id",
      as: "product_details",
    },
  },
  {
    $unwind: "$product_details",
  },
  {
    $project: {
      product_id: "$_id",
      brand: "$product_details.brand",
      price: "$product_details.price",
      category_id: "$product_details.category.category_id",
      category_code: "$product_details.category.category_code",
      popularity: 1,
      user_interaction_score: 1,
    },
  },
  {
    $sort: {
      user_interaction_score: -1,
      popularity: -1,
    },
  },
  {
    $limit: 10,
  },
]);
