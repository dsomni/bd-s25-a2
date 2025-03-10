var db_name = "bd-a2";
db = connect(`mongodb://localhost/${db_name}`);

db.campaigns.aggregate([
  {
    $project: {
      campaign_id: 1,
      campaign_type: 1,
      with_personalization: "$subject.with_personalization",
    },
  },
  {
    $lookup: {
      from: "messages",
      localField: "campaign_id",
      foreignField: "campaign_id",
      pipeline: [
        {
          $project: {
            is_purchased: 1,
            campaign_id: 1,
            message_type: 1,
          },
        },
      ],
      as: "messages",
    },
  },
  {
    $unwind: {
      path: "$messages",
    },
  },
  {
    $match: {
      $expr: {
        $eq: ["$messages.message_type", "$campaign_type"],
      },
    },
  },
  {
    $project: {
      with_personalization: 1,
      is_purchased: "$messages.is_purchased",
    },
  },
  {
    $group: {
      _id: "$with_personalization",
      total: {
        $count: {},
      },
      purchased: {
        $sum: {
          $toInt: "$is_purchased",
        },
      },
    },
  },
  {
    $group: {
      _id: null,
      docs: {
        $addToSet: "$$ROOT",
      },
    },
  },
  {
    $set: {
      r1: {
        $cond: [
          {
            $eq: [
              {
                $first: "$docs._id",
              },
              true,
            ],
          },
          {
            $divide: [
              {
                $first: "$docs.purchased",
              },
              {
                $first: "$docs.total",
              },
            ],
          },
          {
            $divide: [
              {
                $last: "$docs.purchased",
              },
              {
                $last: "$docs.total",
              },
            ],
          },
        ],
      },
    },
  },
  {
    $set: {
      r2: {
        $cond: [
          {
            $eq: [
              {
                $first: "$docs._id",
              },
              false,
            ],
          },
          {
            $divide: [
              {
                $first: "$docs.purchased",
              },
              {
                $first: "$docs.total",
              },
            ],
          },
          {
            $divide: [
              {
                $last: "$docs.purchased",
              },
              {
                $last: "$docs.total",
              },
            ],
          },
        ],
      },
    },
  },
  {
    $project: {
      purchase_ratio: {
        $divide: ["$r1", "$r2"],
      },
    },
  },
]);
