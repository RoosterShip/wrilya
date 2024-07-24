// SPDX-License-Identifier: GPL-3.0-or-later
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
pragma solidity >=0.8.26;

// ----------------------------------------------------------------------------
// Imports
// ----------------------------------------------------------------------------
import {System} from "@latticexyz/world/src/System.sol";
import "../errors.sol";
import "../ledger.sol";
import "../codegen/index.sol";
import "../codegen/common.sol";

// ----------------------------------------------------------------------------
/**
 * @title MarketSystem
 * @author Chris Jimison
 * @notice MUD.dev based smart contract for setting Market Tuning Values
 */
contract MarketTuningSystem is System {
  /**
   * @dev Set all tuning values for the Market in one shot
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param listFee_ to charge when creating a list order
   * @param listRake_ percentage to charge on sale
   * @param englishFee_ to charge when creating an english auction order
   * @param englishRake_ percentage to charge on auction complete
   * @param englishMinTime_ min time the auction will run in seconds
   * @param englishMaxTime_ mint time the auction will run in seconds
   * @param dutchFee_ to charge when creating a dutch auction order
   * @param dutchRake_ percentage to charge on auction complete
   * @param dutchMinTime_ min time the auction will run in seconds
   * @param dutchMaxTime_ max time the auction will run in seconds
   * @param pennyFee_ to charge when creating a penny auction
   * @param pennyRake_ percentage to charge on auction complete
   * @param pennyMinTime_ min time the auction will run in seconds
   * @param pennyMaxTime_ max time the auction will run in seconds
   */
  function marketTuningSet(
    uint256 listFee_,
    uint256 listRake_,
    uint256 englishFee_,
    uint256 englishRake_,
    uint256 englishMinTime_,
    uint256 englishMaxTime_,
    uint256 dutchFee_,
    uint256 dutchRake_,
    uint256 dutchMinTime_,
    uint256 dutchMaxTime_,
    uint256 pennyFee_,
    uint256 pennyRake_,
    uint256 pennyMinTime_,
    uint256 pennyMaxTime_
  ) public {
    //---------------------------------
    // Logic Block
    //---------------------------------
    marketTuningSetList(listFee_, listRake_);
    marketTuningSetEnglish(
      englishFee_, englishRake_, englishMinTime_, englishMaxTime_
    );
    marketTuningSetDutch(dutchFee_, dutchRake_, dutchMinTime_, dutchMaxTime_);
    marketTuningSetPenny(pennyFee_, pennyRake_, pennyMinTime_, pennyMaxTime_);
  }

  /**
   * @dev Set list order tuning values for the Market
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param listFee_ to charge when creating a list order
   * @param listRake_ percentage to charge on sale
   */
  function marketTuningSetList(uint256 listFee_, uint256 listRake_) public {
    //---------------------------------
    // Verification Block
    //---------------------------------

    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    MPTuning.setListFee(listFee_);
    MPTuning.setListRake(listRake_);
  }

  /**
   * @dev Set english auction tuning values for the Market
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param englishFee_ to charge when creating an english auction order
   * @param englishRake_ percentage to charge on auction complete
   * @param englishMinTime_ min time the auction will run in seconds
   * @param englishMaxTime_ mint time the auction will run in seconds
   */
  function marketTuningSetEnglish(
    uint256 englishFee_,
    uint256 englishRake_,
    uint256 englishMinTime_,
    uint256 englishMaxTime_
  ) public {
    marketTuningSetEnglishCosts(englishFee_, englishRake_);
    marketTuningSetEnglishTimes(englishMinTime_, englishMaxTime_);
  }

  /**
   * @dev Set english auction tuning cost values
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param englishFee_ to charge when creating a english auction order
   * @param englishRake_ percentage to charge on auction complete
   */
  function marketTuningSetEnglishCosts(
    uint256 englishFee_,
    uint256 englishRake_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    MPTuning.setEnglishFee(englishFee_);
    MPTuning.setEnglishRake(englishRake_);
  }

  /**
   * @dev Set english auction tuning time values for the Market
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param englishMinTime_ min time the auction will run in seconds
   * @param englishMaxTime_ max time the auction will run in seconds
   */
  function marketTuningSetEnglishTimes(
    uint256 englishMinTime_,
    uint256 englishMaxTime_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());
    require(englishMinTime_ <= englishMaxTime_, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------

    MPTuning.setEnglishMinTime(englishMinTime_);
    MPTuning.setEnglishMaxTime(englishMaxTime_);
  }

  /**
   * @dev Set dutch auction tuning values for the Market
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param dutchFee_ to charge when creating a dutch auction order
   * @param dutchRake_ percentage to charge on auction complete
   * @param dutchMinTime_ min time the auction will run in seconds
   * @param dutchMaxTime_ max time the auction will run in seconds
   */
  function marketTuningSetDutch(
    uint256 dutchFee_,
    uint256 dutchRake_,
    uint256 dutchMinTime_,
    uint256 dutchMaxTime_
  ) public {
    marketTuningSetDutchCosts(dutchFee_, dutchRake_);
    marketTuningSetDutchTimes(dutchMinTime_, dutchMaxTime_);
  }

  /**
   * @dev Set dutch auction tuning cost values
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param dutchFee_ to charge when creating a dutch auction order
   * @param dutchRake_ percentage to charge on auction complete
   */
  function marketTuningSetDutchCosts(
    uint256 dutchFee_,
    uint256 dutchRake_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    MPTuning.setDutchFee(dutchFee_);
    MPTuning.setDutchRake(dutchRake_);
  }

  /**
   * @dev Set dutch auction tuning time values for the Market
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param dutchMinTime_ min time the auction will run in seconds
   * @param dutchMaxTime_ max time the auction will run in seconds
   */
  function marketTuningSetDutchTimes(
    uint256 dutchMinTime_,
    uint256 dutchMaxTime_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());
    require(dutchMinTime_ <= dutchMaxTime_, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------

    MPTuning.setDutchMinTime(dutchMinTime_);
    MPTuning.setDutchMaxTime(dutchMaxTime_);
  }

  /**
   * @dev Set penny auction tuning values for the Market
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param pennyFee_ to charge when creating a penny auction order
   * @param pennyRake_ percentage to charge on auction complete
   * @param pennyMinTime_ min time the auction will run in seconds
   * @param pennyMaxTime_ max time the auction will run in seconds
   */
  function marketTuningSetPenny(
    uint256 pennyFee_,
    uint256 pennyRake_,
    uint256 pennyMinTime_,
    uint256 pennyMaxTime_
  ) public {
    marketTuningSetPennyCosts(pennyFee_, pennyRake_);
    marketTuningSetPennyTimes(pennyMinTime_, pennyMaxTime_);
  }

  /**
   * @dev Set penny auction tuning cost values
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param pennyFee_ to charge when creating a penny auction order
   * @param pennyRake_ percentage to charge on auction complete
   */
  function marketTuningSetPennyCosts(
    uint256 pennyFee_,
    uint256 pennyRake_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------

    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());

    //---------------------------------
    // Logic Block
    //---------------------------------

    MPTuning.setPennyFee(pennyFee_);
    MPTuning.setPennyRake(pennyRake_);
  }

  /**
   * @dev Set penny auction tuning time values for the Market
   *
   * Requirements:
   *
   * - Only the Governor can call this function
   *
   * @param pennyMinTime_ min time the auction will run in seconds
   * @param pennyMaxTime_ max time the auction will run in seconds
   */
  function marketTuningSetPennyTimes(
    uint256 pennyMinTime_,
    uint256 pennyMaxTime_
  ) public {
    //---------------------------------
    // Verification Block
    //---------------------------------

    require(GameConfig.getGovernor() == _msgSender(), Unauthorized());
    require(pennyMinTime_ <= pennyMaxTime_, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------

    MPTuning.setPennyMinTime(pennyMinTime_);
    MPTuning.setPennyMaxTime(pennyMaxTime_);
  }
}
